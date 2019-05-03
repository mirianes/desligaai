//
//  DispositivosCollectionViewController.swift
//  DesligaAi
//
//  Created by Alícia Reis on 24/04/19.
//  Copyright © 2019 desligaAi. All rights reserved.
//

import UIKit
import UserNotifications

private let reuseIdentifier = "dispositivoCell"

class DispositivosCollectionViewController: UICollectionViewController, UNUserNotificationCenterDelegate {
    
    var dispositivos = [Device]()
    var dispositivoSelected: Device?
    
    var notificationCenter: UNUserNotificationCenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let body = ["idUser" : "0953FB4C-27DB-4438-B7CD-4B38515D9C9C"]//UIDevice.current.identifierForVendor!.uuidString]
        DeviceCRUD.listDevices(body,{ (devices) in
            self.dispositivos = devices
            self.collectionView?.reloadData()
        })
        
        self.notificationCenter = UNUserNotificationCenter.current()
        notificationCenter?.delegate = self
        
        let options: UNAuthorizationOptions = [.alert, .sound]
        self.notificationCenter?.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Permission not granted")
            } else {
                print("Permission granted")
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "DesligaAí"
        content.body = "Você esqueceu um aparelho ligado que estava habilitado para ser desligado automaticamente, então o desliguei."
        content.sound = UNNotificationSound.default()
        
        let date = Date(timeIntervalSinceNow: 120)
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        let identifier = "ExitHome"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter?.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error.localizedDescription)
                // Something went wrong
            } else {
                self.turnOff()
            }
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    func turnOff() {
        let body = ["payload": 1]
        DeviceCRUD.turnOffDevice(body, {(state) in
            print(state)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "deviceDetailsSegue" {
            if let destination = segue.destination as? InfoDeviceViewController {
                destination.device = self.dispositivoSelected
            }
        }
     }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dispositivos.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dispositivoCell", for: indexPath)
        
        if let dispositivoCell = cell as? DispositivoCollectionViewCell{
            
            if indexPath.item == self.dispositivos.count {
                dispositivoCell.deviceNameLabel.text = "Adicionar Dispositivo"
                dispositivoCell.deviceIconImageView.image = UIImage(named: "NewDevice")
            } else {
                let dispositivo = self.dispositivos[indexPath.item]
                dispositivoCell.deviceNameLabel.text = dispositivo.equipamentName
                dispositivoCell.deviceIconImageView.image = UIImage(named: dispositivo.photoImage)
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == self.dispositivos.count {
            performSegue(withIdentifier: "newDeviceSegue", sender: self)
        } else {
            DeviceCRUD.getConsumption([:], { (result) in
                self.dispositivoSelected = self.dispositivos[indexPath.item]
                self.dispositivoSelected?.consumption = Double(result) ?? 125.7
                print("Segundo \(String(describing: self.dispositivoSelected?.consumption))")
                self.performSegue(withIdentifier: "deviceDetailsSegue", sender: self)
                print("Result \(result)")
            })
        }
    }
    
    @IBAction func backToHome(segue: UIStoryboardSegue){
    }

    // MARK: UICollectionViewDelegate

    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */

    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */

    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */

}



