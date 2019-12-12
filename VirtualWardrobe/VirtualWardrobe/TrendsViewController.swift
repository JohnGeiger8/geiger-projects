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
    
    var clothesQuantityXAxis : [String:Int]?
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure our bar chart
        configureChart()
        chartView.backgroundColor = .backgroundColor
    }
    
    override func viewDidLayoutSubviews() {
        
        var graphBars : [(String, Double)] = []
        for (year, count) in clothesQuantityXAxis! {
            graphBars.append((year, Double(count)))
        }
        graphBars.sort(by: { Int($0.0)! < Int($1.0)! }) // Sort by year
        
        barChart = BarsChart(frame: chartView.frame, chartConfig: chartConfiguration, xTitle: "Year", yTitle: "Items Purchased", bars: graphBars, color: .blue, barWidth: 30.0)
        barChart!.contentView
        mainScrollView.addSubview(barChart!.view)
        mainScrollView.contentSize = view.frame.size
    }
    
    func configureChart() {
        
        // Add space around edges of chart
        chartSettings.top = 15
        chartSettings.bottom = 15
        chartSettings.trailing = 15
        chartSettings.leading = 15
        
        //chartLabelSettings.font
        
        clothesQuantityXAxis = wardrobeModel.clothesBy("Year", sizeOfTimePeriod: 5)
        let maxY = Double(clothesQuantityXAxis!.max(by: { a,b in a.1 < b.1 })!.value)
        chartConfiguration = BarsChartConfig(chartSettings: chartSettings, valsAxisConfig: ChartAxisConfig(from: 0.0, to: maxY, by: maxY / 4.0), xAxisLabelSettings: chartLabelSettings, yAxisLabelSettings: chartLabelSettings, guidelinesConfig: GuidelinesConfig())
    }

    @IBAction func changeGraphFilter(_ sender: Any) {
        
        
    }
}
