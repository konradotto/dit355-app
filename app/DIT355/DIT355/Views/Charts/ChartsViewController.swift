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
    @IBOutlet weak var lineChartView: LineChartView!
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    //MARK: - Class Variables
    private lazy var mapController  = MapController.shared
    
    //MARK: - ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .linear)
        pieChartView.animate(xAxisDuration: 1.0, easingOption: .easeInCirc)
    }
   
    
    //MARK: - Class Functions
    func initView(){
        axisFormatDelegate = self
        pieChartView.noDataText = "No data to visualize"
        let dataArray = mapController.annotations
        guard dataArray.count > 1 else {return}
        
        let filteredAnnotations = dataArray.filter({$0.title == "Source"})
        let tramCount =  Double(filteredAnnotations.filter({$0.type == "tram"}).count)
        let busCount  =  Double(filteredAnnotations.filter({$0.type == "bus"}).count)
        let ferryCount = Double(filteredAnnotations.filter({$0.type == "ferry"}).count)
        let types = ["tram", "bus", "ferry"]
        let typesCount = [tramCount, busCount, ferryCount]
        setPieChart(dataPoints: types, values: typesCount)
        
        let dates = filteredAnnotations.map { (ann) -> String in
            ann.departureTime.components(separatedBy: " ").first!
        }
        let filteredDates = dates.removeDuplicates()
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        let actualDates = filteredDates.compactMap { df.date(from: $0) }
        let sortedDates = actualDates.sorted { $0 < $1 }
        let intervals = sortedDates.map { (d) -> TimeInterval in
            d.timeIntervalSince1970
        }
        let dateStringsSorted = sortedDates.compactMap { df.string(from: $0)}
        
        var dateCounts = [Int]()
        for date in dateStringsSorted {
            dateCounts.append(dates.filter({ (d) -> Bool in
            d == date }).count)
        }
        setLineChart(dataPoints: intervals, values: dateCounts)
        
        
    }
    
    
    func setLineChart(dataPoints: [TimeInterval],values: [Int]){
        
        var dataEntries = [ChartDataEntry]()
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(dataPoints[i]), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Requests per day")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
        lineChartDataSet.colors = ChartColorTemplates.material()
        let xaxis = lineChartView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
        lineChartView.xAxis.labelPosition = .bottom
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.valueTextColor = .white
        lineChartView.noDataTextColor = .white
        lineChartView.tintColor = .lightGray
        lineChartView.borderColor = .black
        lineChartView.isUserInteractionEnabled = false
    }
    
    func setPieChart(dataPoints: [String], values: [Double]) {
        
        var pieDataEntries: [PieChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let pieEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            pieDataEntries.append(pieEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: pieDataEntries, label: "total count: \(mapController.annotations.count/2)")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartDataSet.colors = [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
        pieChartDataSet.valueTextColor = .white
        pieChartView.entryLabelColor = .white
        pieChartView.holeColor = .darkGray
        pieChartView.noDataTextColor = .white
        pieChartView.isUserInteractionEnabled = false
    }
}
// MARK: axisFormatDelegate
extension ChartsViewController: IAxisValueFormatter {
  
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd"
    return dateFormatter.string(from: Date(timeIntervalSince1970: value))
  }
  
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }

        return result
    }
}
