//
//  ChartsViewController.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-12-05.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    private lazy var mapController  = MapController.shared
    private lazy var dataarray      = [Annotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
    
    func initView(){
        pieChartView.noDataText = "No data to visualize"
        
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        setChart(dataPoints: months, values: unitsSold)
        
    }

    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        var barDataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
    
            let entry = BarChartDataEntry(x: values[i], y: Double(i))
            barDataEntries.append(entry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        
        
        
        let chartDataSet = BarChartDataSet(entries: barDataEntries, label: "Units Sold")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
    }
}
