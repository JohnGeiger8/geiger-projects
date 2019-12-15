//
//  TrendsViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 12/9/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit
import SwiftCharts

class TrendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    @IBOutlet weak var trendsTableView: UITableView!
    
    let font = UIFont(name: "Marker Felt", size: 10)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure our bar chart
        configureChart(withTimePeriod: "Year")
        configureTableView()
        chartView.backgroundColor = .backgroundColor
    }
    
    override func viewDidLayoutSubviews() {
        
        barChart?.view.removeFromSuperview()
        
        var graphBars : [(String, Double)] = []
        for (timePeriod, count) in clothesQuantityXAxis! {
            graphBars.append((timePeriod, Double(count)))
        }
        graphBars.sort(by: { Int($0.0)! < Int($1.0)! })
        
        var chartFrame = chartView.frame
        chartFrame.size.width = self.view.frame.width - chartFrame.origin.x * 2
        barChart = BarsChart(frame: chartFrame, chartConfig: chartConfiguration, xTitle: barXAxisTitle, yTitle: barYAxisTitle, bars: graphBars, color: .navigationColor, barWidth: CGFloat(barWidth))

        mainScrollView.addSubview(barChart!.view)
        mainScrollView.contentSize = view.frame.size
    }
    
    // MARK:- Chart
    
    func configureChart(withTimePeriod period: String) {
        
        // Add space around edges of chart
        chartSettings.top = 15
        chartSettings.bottom = 15
        chartSettings.trailing = 15
        chartSettings.leading = 15
        
        chartLabelSettings.font = UIFont(name: "Marker Felt", size: 10)!
        chartLabelSettings.fontColor = .primaryTextColor
        chartLabelSettings.shiftXOnRotation = true
        
        clothesQuantityXAxis = wardrobeModel.clothesBy(period, sizeOfTimePeriod: 5)
        var maxY = Double(clothesQuantityXAxis!.max(by: { a,b in a.1 < b.1 })!.value)
        maxY = max(maxY, 1.0) // Prevents crash when no items in graph
        
        chartConfiguration = BarsChartConfig(chartSettings: chartSettings, valsAxisConfig: ChartAxisConfig(from: 0.0, to: maxY, by: maxY / 4.0), xAxisLabelSettings: chartLabelSettings, yAxisLabelSettings: chartLabelSettings, guidelinesConfig: GuidelinesConfig())
    }

    @IBAction func changeGraphFilter(_ sender: UISegmentedControl) {
        // FIXME: weeks not implemented
        let selectedIndex = sender.selectedSegmentIndex
        
        configureChart(withTimePeriod: sender.titleForSegment(at: selectedIndex)!)
        
        barXAxisTitle = sender.titleForSegment(at: selectedIndex)!
        self.view.setNeedsLayout()
    }
    
    // MARK:- Trends
    
    func configureTableView() {
        
        wardrobeModel.findTrends()
        trendsTableView.dataSource = self
        trendsTableView.delegate = self
        trendsTableView.allowsSelection = false
        trendsTableView.backgroundColor = .navigationColor
        trendsTableView.contentInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        trendsTableView.contentSize = CGSize(width: trendsTableView.frame.width, height: trendsTableView.contentSize.height) // Prevent horizontal scrolling
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wardrobeModel.numberOfTrends
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendCell", for: indexPath)
        
        let trendName = wardrobeModel.trendNameAt(indexPath: indexPath)
        cell.textLabel?.text = trendName
        cell.textLabel?.font = font
        cell.textLabel?.textColor = .primaryTextColor
        cell.detailTextLabel?.text = wardrobeModel.favoriteOf(trendName)
        cell.detailTextLabel?.font = UIFont(name: font.fontName, size: 14.0)
        cell.backgroundColor = .backgroundColor

        return cell
    }
}
