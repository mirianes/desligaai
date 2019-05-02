//
//  InfoDeviceViewController.swift
//  DesligaAi
//
//  Created by student on 30/04/19.
//  Copyright © 2019 desligaAi. All rights reserved.
//

import UIKit

class InfoDeviceViewController: UIViewController {

    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var consumptionLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    var device: Device?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
