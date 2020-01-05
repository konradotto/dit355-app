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

    //MARK: - UI Elements
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    //MARK: - Class Variables
    private lazy var mapController  = MapController.shared
    
    //MARK: - ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBounce)
        pieChartView.animate(xAxisDuration: 1.0, easingOption: .easeInCirc)
    }

    
    //MARK: - Class Functions
    func initView(){
        pieChartView.noDataText = "No data to visualize"
        let dataArray = mapController.annotations
        guard dataArray.count > 1 else {return}
        
        let filteredAnnotations = dataArray.filter({$0.title == "Source"})
        let tramCount =  Double(filteredAnnotations.filter({$0.type == "tram"}).count)
        let busCount  =  Double(filteredAnnotations.filter({$0.type == "bus"}).count)
        let ferryCount = Double(filteredAnnotations.filter({$0.type == "ferry"}).count)
        
        
        let types = ["tram", "bus", "ferry"]
        let typesCount = [tramCount, busCount, ferryCount]
        setChart(dataPoints: types, values: typesCount)
        
    }
    func setChart(dataPoints: [String], values: [Double]) {
        
        var pieDataEntries: [PieChartDataEntry] = []
        var barDataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let pieEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            let barEntry = BarChartDataEntry(x: Double(i), y: values[i],data: dataPoints[i].data(using: .utf8))
            pieDataEntries.append(pieEntry)
            barDataEntries.append(barEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: pieDataEntries, label: "total count: \(mapController.annotations.count/2)")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        
        pieChartDataSet.colors = [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
        pieChartView.isUserInteractionEnabled = false
        barChartView.isUserInteractionEnabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.avoidFirstLastClippingEnabled = true
       // barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        let barChartDataSet = BarChartDataSet(entries: barDataEntries,label: "Time interval")
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartView.data = barChartData
        barChartDataSet.setColor(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
        barChartView.chartDescription?.text = ""
        
    }
}
