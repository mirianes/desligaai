//
//  TabBarViewController.swift
//  DesligaAi
//
//  Created by Miriane Silva on 30/04/2019.
//  Copyright © 2019 desligaAi. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let barViewControllers = segue.destination as? UITabBarController, let destination = barViewControllers.viewControllers?[0] as? TotalConsumptionViewController {
            print(destination)
            if let originBarView = segue.source as? UITabBarController, let origin = originBarView.viewControllers?[1] as? DispositivosCollectionViewController {
                destination.devices = origin.dispositivos
            }
        }
    }

}
