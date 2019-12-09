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
    var chartView : ChartView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
        barChart = BarsChart(frame: CGRect(x: 10.0, y: 100.0, width: self.view.frame.width, height: self.view.frame.height / 2.0), chartConfig: BarsChartConfig(valsAxisConfig: ChartAxisConfig(from: 0.0, to: 100.0, by: 50.0)), xTitle: "X axis", yTitle: "y axis", bars: [("A",10.0), ("B",20.0), ("C", 30.0)], color: .blue, barWidth: 30.0)
        
        view.addSubview(barChart!.view)
    }

}
