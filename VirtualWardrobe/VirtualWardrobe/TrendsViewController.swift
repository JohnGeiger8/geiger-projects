//
//  TrendsViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 12/9/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit
import SwiftCharts

class TrendsViewController: UIViewController {
    
    let wardrobeModel = WardrobeModel.sharedinstance
    
    // Chart stuff
    var barChart : BarsChart?
    var chartConfiguration : BarsChartConfig!
    var chartSettings = ChartSettings()
    var chartLabelSettings = ChartLabelSettings()
    let barWidth = 25.0
    var barXAxisTitle = "Year"
    var barYAxisTitle = "Items Purchased"
    
    var clothesQuantityXAxis : [String:Int]?
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure our bar chart
        configureChart(withTimePeriod: "Year")
        chartView.backgroundColor = .backgroundColor
    }
    
    override func viewDidLayoutSubviews() {
        
        barChart?.view.removeFromSuperview()
        
        var graphBars : [(String, Double)] = []
        for (year, count) in clothesQuantityXAxis! {
            graphBars.append((year, Double(count)))
        }
        graphBars.sort(by: { Int($0.0)! < Int($1.0)! }) // Sort by year
        
        var chartFrame = chartView.frame
        chartFrame.size.width = self.view.frame.width - chartFrame.origin.x * 2
        barChart = BarsChart(frame: chartFrame, chartConfig: chartConfiguration, xTitle: barXAxisTitle, yTitle: barYAxisTitle, bars: graphBars, color: .navigationColor, barWidth: CGFloat(barWidth))

        mainScrollView.addSubview(barChart!.view)
        mainScrollView.contentSize = view.frame.size
    }
    
    func configureChart(withTimePeriod period: String) {
        
        // Add space around edges of chart
        chartSettings.top = 15
        chartSettings.bottom = 15
        chartSettings.trailing = 15
        chartSettings.leading = 15
        
        //chartLabelSettings.font
        
        clothesQuantityXAxis = wardrobeModel.clothesBy(period, sizeOfTimePeriod: 5)
        let maxY = Double(clothesQuantityXAxis!.max(by: { a,b in a.1 < b.1 })!.value)
        chartConfiguration = BarsChartConfig(chartSettings: chartSettings, valsAxisConfig: ChartAxisConfig(from: 0.0, to: maxY, by: maxY / 4.0), xAxisLabelSettings: chartLabelSettings, yAxisLabelSettings: chartLabelSettings, guidelinesConfig: GuidelinesConfig())
    }

    @IBAction func changeGraphFilter(_ sender: UISegmentedControl) {
        // FIXME: weeks not implemented
        let selectedIndex = sender.selectedSegmentIndex
        guard sender.titleForSegment(at: selectedIndex)! != "Week" else { return }
        
        configureChart(withTimePeriod: sender.titleForSegment(at: selectedIndex)!)
        
        barXAxisTitle = sender.titleForSegment(at: selectedIndex)!
        self.view.setNeedsLayout()
    }
}
