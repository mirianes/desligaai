//
//  InfoDeviceViewController.swift
//  DesligaAi
//
//  Created by student on 30/04/19.
//  Copyright © 2019 desligaAi. All rights reserved.
//

import UIKit
import Charts

class InfoDeviceViewController: UIViewController {

    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var consumptionLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var choiceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    
    var device: Device?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lineChartView.chartDescription?.enabled = false
        self.lineChartView.xAxis.drawGridLinesEnabled = false
        self.lineChartView.xAxis.labelPosition = .bottom
        self.lineChartView.highlightPerTapEnabled = false
        self.lineChartView.leftAxis.drawGridLinesEnabled = false
        self.lineChartView.leftAxis.drawAxisLineEnabled = false
        self.lineChartView.rightAxis.drawGridLinesEnabled = false
        self.lineChartView.rightAxis.drawLabelsEnabled = false
//        self.lineChartView.legend.enabled = false
        
        if let device = device {
            self.setChartDayValues(device.consumptionDay)
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let title = device?.equipamentName, let name = device?.name, let consuption = device?.consumption, let state = device?.state {
            self.navigationItem.title = title
            self.deviceLabel.text = "Conectado ao Dispositivo \(name)"
            self.consumptionLabel.text = "Consumo Instantâneo \(consuption) kWh"
            var stateMessage = "Atualmente o equipamento está "
            if state {
                stateMessage += "ligado"
            } else {
                stateMessage += "desligado"
            }
            self.stateLabel.text = stateMessage
        } else {
            self.reloadInputViews()
        }
        self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChartDayValues (_ data: [String]) {
        if data.count > 0 {
//            let values = (0..<data.count).map({ (item) -> ChartDataEntry in
//                let val = data[item]
//                return ChartDataEntry(x: Double(item), y: Double(val)!)
//            })
            
//            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date.init())
            
            let timesInterval = (0..<data.count).map({ (item) -> TimeInterval in
                let newDate = Calendar.current.date(byAdding: .hour, value: item - 24, to: Date.init())
                return (newDate?.timeIntervalSince1970)!
            })
            let referenceTimeInterval: TimeInterval = timesInterval.min()!
            
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            formatter.locale = Locale.current
            
            let xValuesNumberFormatter = LineChartFormatter.init(referenceTimeInterval, dateFormatter: formatter)
            
            var values = [ChartDataEntry]()
            
            for item in (0..<data.count) {
                let timeInterval = Date.init().timeIntervalSince1970
                let xValue = (timesInterval[item] - timeInterval) / (3600*24)
                let yValue = Double(data[item])!
                let entry = ChartDataEntry(x: xValue, y: yValue)
                values.append(entry)
            }
            
            self.lineChartView.xAxis.valueFormatter = xValuesNumberFormatter
 
            let set = LineChartDataSet(values: values, label: "Consumo Diário")
            set.drawCirclesEnabled = false
            set.mode = .cubicBezier
            let chartData = LineChartData(dataSet: set)
            self.lineChartView.data = chartData
        }
    }
    
    func setChartMonthValues (_ data: [String]) {
        if data.count > 0 {
            let timesInterval = (0..<data.count).map({ (item) -> TimeInterval in
                let newDate = Calendar.current.date(byAdding: .day, value: item + 1 - data.count, to: Date.init())
                return (newDate?.timeIntervalSince1970)!
            })
            let referenceTimeInterval: TimeInterval = timesInterval.min()!
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            formatter.locale = Locale.current
            
            let xValuesNumberFormatter = LineChartFormatter.init(referenceTimeInterval, dateFormatter: formatter)
            
            var values = [ChartDataEntry]()
            
            for item in (0..<data.count) {
                let timeInterval = Date.init().timeIntervalSince1970
                let xValue = (timesInterval[item] - timeInterval) / (3600*24)
                let yValue = Double(data[item])!
                let entry = ChartDataEntry(x: xValue, y: yValue)
                values.append(entry)
            }
            
            self.lineChartView.xAxis.valueFormatter = xValuesNumberFormatter
            
            let set = LineChartDataSet(values: values, label: "Consumo Mensal")
            set.drawCirclesEnabled = false
            set.mode = .cubicBezier
            let chartData = LineChartData(dataSet: set)
            self.lineChartView.data = chartData
        }
    }

    @IBAction func setGraphType(_ sender: Any) {
        switch self.choiceSegmentedControl.selectedSegmentIndex {
        case 0:
            if let consumptionDay = self.device?.consumptionDay {
                self.setChartDayValues(consumptionDay)
            }
        case 1:
            if let consumptionMonth = self.device?.consumptionMonth {
                self.setChartMonthValues(consumptionMonth)
            }
        default:
            print("error")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class LineChartFormatter: NSObject, IAxisValueFormatter {
    var dateFormatter: DateFormatter?
    var referenceTimeInterval: TimeInterval?
    
    init(_ referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
        self.referenceTimeInterval = referenceTimeInterval
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter, let referenceTimeInterval = referenceTimeInterval else {
            return ""
        }
        
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }
    
}
