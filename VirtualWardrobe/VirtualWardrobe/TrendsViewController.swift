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
    
    var barChart : BarsChart?
    @IBOutlet weak var chartView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
        // Configure our bar graph
        let chartConfiguration = BarsChartConfig(chartSettings: ChartSettings(), valsAxisConfig: ChartAxisConfig(from: 0.0, to: 50.0, by: 10.0), xAxisLabelSettings: ChartLabelSettings(), yAxisLabelSettings: ChartLabelSettings(), guidelinesConfig: GuidelinesConfig())
        
        barChart = BarsChart(frame: chartView.frame, chartConfig: chartConfiguration, xTitle: "Year", yTitle: "Items Purchased", bars: [("2017",10.0), ("2018",20.0), ("2019", 30.0)], color: .blue, barWidth: 30.0)
        
        view.addSubview(barChart!.view)
    }

}
