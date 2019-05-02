//
//  totalConsumptionViewController.swift
//  DesligaAi
//
//  Created by Miriane Silva on 02/05/2019.
//  Copyright © 2019 desligaAi. All rights reserved.
//

import UIKit
import Charts

class TotalConsumptionViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    
    var devices = [Device]()
    
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
        
        self.setChartValues()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChartValues () {
        if self.devices.count > 0 {
            var length = 0
            for device in self.devices {
                if device.consumptionMonth.count > length {
                    length = device.consumptionMonth.count
                }
            }
            let timesInterval = (0..<length).map({ (item) -> TimeInterval in
                let newDate = Calendar.current.date(byAdding: .day, value: item - 30, to: Date.init())
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
            
            for device in self.devices {
                var values = [ChartDataEntry]()
                for item in (0..<length) {
                    let timeInterval = Date.init().timeIntervalSince1970
                    let xValue = (timesInterval[item] - timeInterval) / (3600*24)
                    let yValue = device.consumptionMonth[item]
                    let entry = ChartDataEntry(x: xValue, y: Double(yValue)!)
                    values.append(entry)
                }
                
                self.lineChartView.xAxis.valueFormatter = xValuesNumberFormatter
                
                let set = LineChartDataSet(values: values, label: device.equipamentName)
                set.drawCirclesEnabled = false
                set.mode = .cubicBezier
                let chartData = LineChartData(dataSet: set)
                self.lineChartView.data = chartData
            }
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
