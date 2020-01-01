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

    @IBOutlet weak var pieTypeChartView: PieChartView!
    @IBOutlet weak var piePurposeChartView: PieChartView!
    
    private lazy var mapController  = MapController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
    
    
    func initView(){
        pieTypeChartView.noDataText = "No data to visualize"
        let dataArray = mapController.annotations
        guard dataArray.count > 1 else {return}
        
        let filteredAnnotations = dataArray.filter({$0.title == "Source"})
        let tramCount    = Double(filteredAnnotations.filter({$0.type == "tram"}).count)
        let busCount     = Double(filteredAnnotations.filter({$0.type == "bus"}).count)
        let ferryCount   = Double(filteredAnnotations.filter({$0.type == "ferry"}).count)
        let workCount    = Double(filteredAnnotations.filter({$0.subtitle == "work"}).count)
        let schoolCount  = Double(filteredAnnotations.filter({$0.subtitle == "school"}).count)
        let leisureCount = Double(filteredAnnotations.filter({$0.subtitle == "leisure"}).count)
        let tourismCount = Double(filteredAnnotations.filter({$0.subtitle == "tourism"}).count)
        
        let types = ["tram", "bus", "ferry"]
        let purposes = ["work", "school", "leisure", "tourism"]
        let typesCount = [tramCount, busCount, ferryCount]
        let purposesCount = [workCount, schoolCount, leisureCount, tourismCount]
        setChart(dataPointsType: types, valuesType: typesCount, dataPointsPurpose: purposes, valuesPurpose: purposesCount)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        pieTypeChartView.animate(xAxisDuration: 1.0, easingOption: .easeInCirc)
        piePurposeChartView.animate(xAxisDuration: 1.0, easingOption: .easeInCirc)
    }

   
    
    func setChart(dataPointsType: [String], valuesType: [Double], dataPointsPurpose: [String], valuesPurpose: [Double]) {
        
        var pieDataEntriesType:     [PieChartDataEntry] = []
        var pieDataEntriesPurpose:  [PieChartDataEntry] = []
        
        for i in 0..<dataPointsType.count {
            let pieEntry = PieChartDataEntry(value: valuesType[i], label: dataPointsType[i])
            pieDataEntriesType.append(pieEntry)
        }
        
        for i in 0..<dataPointsPurpose.count {
                  let pieEntry = PieChartDataEntry(value: valuesPurpose[i], label: dataPointsPurpose[i])
                  pieDataEntriesPurpose.append(pieEntry)
              }
        
        let pieChartDataSetType = PieChartDataSet(entries: pieDataEntriesType, label: "total count: \(mapController.annotations.count/2)")
        let pieChartDataSetPurpose = PieChartDataSet(entries: pieDataEntriesPurpose, label: "total count: \(mapController.annotations.count/2)")
        let pieChartDataType = PieChartData(dataSet: pieChartDataSetType)
        let pieChartDataPurpose = PieChartData(dataSet: pieChartDataSetPurpose)
        pieTypeChartView.data = pieChartDataType
        piePurposeChartView.data = pieChartDataPurpose
        
        pieChartDataSetType.colors = [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
        pieChartDataSetPurpose.colors = [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),.yellow]
        pieTypeChartView.isUserInteractionEnabled = false
        piePurposeChartView.isUserInteractionEnabled = false
        
        
    }
}
