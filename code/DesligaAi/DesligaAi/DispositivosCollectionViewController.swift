//
//  DispositivosCollectionViewController.swift
//  DesligaAi
//
//  Created by Alícia Reis on 24/04/19.
//  Copyright © 2019 desligaAi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "dispositivoCell"

class DispositivosCollectionViewController: UICollectionViewController {
    
    var dispositivos = [Device]()
    var dispositivoSelected: Device?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dispositivos = [Device(["equipament": "Televisão", "name": "D001", "state": false, "consumption": "127"]),
                             Device(["equipament": "Geladeira", "name": "D002", "state": false]),
                             Device(["equipament": "Ar-condicionado", "name": "D003", "state": false]),
                             Device(["equipament": "TV do quarto", "name": "D004", "state": true, "consumption": "127"])]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
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
            self.dispositivoSelected = self.dispositivos[indexPath.item]
            performSegue(withIdentifier: "deviceDetailsSegue", sender: self)
        }
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



