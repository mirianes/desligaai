//
//  DispositivosCollectionViewController.swift
//  DesligaAi
//
//  Created by student on 24/04/19.
//  Copyright © 2019 desligaAi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "dispositivoCell"

class DispositivosCollectionViewController: UICollectionViewController {
    
    var dispositivos = [Device]()
    var dispositivoSelected: Device?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //não sei o que faz aqui
        
        print("olá")
        
        self.dispositivos = [Device(["equipamento": "Televisão", "nome": "D001", "estado": false]),
                             Device(["equipamento": "Geladeira", "nome": "D002", "estado": false]),
                             Device(["equipamento": "Ar-condicionado", "nome": "D003", "estado": false]),
                             Device(["equipamento": "TV do quarto", "nome": "D004", "estado": true])]
        
        //        self.dispositivos = DeviceCRUD.createDevice(<#T##body: [String : String]##[String : String]#>, <#T##callback: ((Bool) -> Void)##((Bool) -> Void)##(Bool) -> Void#>)
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.dispositivos.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dispositivoCell", for: indexPath)
        
        if let dispositivoCell = cell as? DispositivoCollectionViewCell{
            
            //se chegar no último dispositivo ele vai printar uma céclula p add outro
            
            if indexPath.item == self.dispositivos.count {
                
                dispositivoCell.deviceNameLabel.text = "Adicionar Dispositivo"
                
                dispositivoCell.deviceIconImageView.image = UIImage(named: "14866")
                
            } else{
                
                let dispositivo = self.dispositivos[indexPath.item]
                
                dispositivoCell.deviceNameLabel.text = dispositivo.equipTextField
                
                dispositivoCell.deviceIconImageView.image = UIImage(named: dispositivo.fotoImage)
                
            }
        }
        
        
        return cell
        
    }
    
    //    override func collectionView(_ collectionView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        self.dispositivoSelected = dispositivos[indexPath.row]
    //        performSegue(withIdentifier: "DeviceIdentifier", sender: self)
    //    }
    //
    //
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destinationViewController.
    //        // Pass the selected object to the new view controller.
    //
    //        if segue.identifier == "DeviceIdentifier" {
    //            if let infoMusic = segue.destination as? InfoDeviceViewController {
    //                infoMusic.album = dispositivoSelected?.capa
    //                infoMusic.albumName = dispositivoSelected?.album
    //                infoMusic.artist = dispositivoSelected?.artist
    //                infoMusic.name = dispositivoSelected?.name
    //            }
    //        }
    //    }
    
    
    
    
    
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

//}



