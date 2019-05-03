//
//  SettingsTableViewController.swift
//  DesligaAi
//
//  Created by Miriane Silva on 01/05/2019.
//  Copyright © 2019 desligaAi. All rights reserved.
//

import UIKit
import MapKit

class SettingsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var dateCellExpanded: Bool = false
    var selectedCell: UITableViewCell?

    var locationManager = CLLocationManager()
    public var homeLocation: CLLocation?
    var geocoder = CLGeocoder()
    
    var questions = ["Quanto de energia é consumido para o funcionamento do dispositivo?",
                     "Como cadastrar um novo dispositivo? O que é QR Code?",
                     "Posso alterar a distância máxima entre o dispositivo e meu iPhone para receber a notificação de desligamento?",
                     "Posso controlar o mesmo dispositivo a partir de diferentes celulares?"]
    var answers = ["O sistema de alimentação da placa e o sistema de alimentação do eletrodoméstico são separados. Logo o dispositivo não afeta a medição de energia, pois a medição ocorre somente no sistema de alimentação do eletrodoméstico.",
                   "Para cadastrar um novo dispositivo basta clicar no botão de '+' na tela inicial do Desligaí! e utilizar o própio aplicativo para ler o código QR localizado no dispositivo. O código QR (ou QR Code) funciona como um código de barras, associando um identificador único para cada dispositivo. Dessa forma, somente você terá acesso aos dados de seu dispositivo.",
                   "Por enquanto, não! Nessa fase do projeto, o Desligaí! configura automaticamente essa distância para 100 metros.",
                   "Por enquanto, não! Seria necessário termos a função de cadastro de usuário, o que ainda não existe no Desligaí!."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
//        let emailLabel = UILabel()
//        emailLabel.text = ""

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell = tableView.cellForRow(at: indexPath)
        self.selectedCell?.contentView.backgroundColor = UIColor.white
        if indexPath.row == 0 {
            if dateCellExpanded {
                if let addressCell = self.selectedCell as? AddressTableViewCell {
                    addressCell.arrowImage.image = #imageLiteral(resourceName: "arrowDown")
                    addressCell.manualAddressStack.isHidden = true
                    addressCell.confirmAddressStack.isHidden = true
                }
                dateCellExpanded = false
            } else {
                if let addressCell = self.selectedCell as? AddressTableViewCell {
                    addressCell.arrowImage.image = #imageLiteral(resourceName: "arrowUp")
                    addressCell.manualAddressStack.isHidden = false
                    addressCell.confirmAddressStack.isHidden = false
                    self.setupLocationManager()
                }
                dateCellExpanded = true
            }
        } else if indexPath.row == 1 {
            if dateCellExpanded {
                if let faqCell = self.selectedCell as? FaqTableViewCell {
                    faqCell.arrowImage.image = #imageLiteral(resourceName: "arrowDown")
                }
                dateCellExpanded = false
            } else {
                if let faqCell = self.selectedCell as? FaqTableViewCell {
                    faqCell.arrowImage.image = #imageLiteral(resourceName: "arrowUp")
                }
                dateCellExpanded = true
            }
        } else if indexPath.row == 2 {
            if dateCellExpanded {
                if let aboutCell = tableView.cellForRow(at: indexPath) as? AboutTableViewCell {
                    aboutCell.arrowImage.image = #imageLiteral(resourceName: "arrowDown")
                }
                dateCellExpanded = false
            } else {
                if let aboutCell = tableView.cellForRow(at: indexPath) as? AboutTableViewCell {
                    aboutCell.arrowImage.image = #imageLiteral(resourceName: "arrowUp")
                }
                dateCellExpanded = true
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.selectedCell as? AddressTableViewCell) != nil && indexPath.row == 0 {
            if dateCellExpanded {
                return 250
            }
        } else if (self.selectedCell as? FaqTableViewCell) != nil && indexPath.row == 1 {
            if dateCellExpanded {
                return 700
            }
        } else if (self.selectedCell as? AboutTableViewCell) != nil && indexPath.row == 2 {
            if dateCellExpanded {
                return 170
            }
        } else if indexPath.row == 3 {
            return 120
        }
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
            if let addressCell = cell as? AddressTableViewCell {
                addressCell.arrowImage.image = #imageLiteral(resourceName: "arrowDown")
                addressCell.titleLabel.text = "Salvar Endereço"
            }
        } else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "faqCell", for: indexPath)
            if let faqCell = cell as? FaqTableViewCell {
                faqCell.arrowImage.image = #imageLiteral(resourceName: "arrowDown")
                faqCell.titleLabel.text = "Perguntas Frequentes"
                faqCell.firsFaqLabel.attributedText = self.makeBoldText(self.questions[0], self.answers[0])
                faqCell.secondFaqLabel.attributedText = self.makeBoldText(self.questions[1], self.answers[1])
                faqCell.thirdFaqLabel.attributedText = self.makeBoldText(self.questions[2], self.answers[2])
                faqCell.fourthFaqLabel.attributedText = self.makeBoldText(self.questions[3], self.answers[3])
            }
        } else if indexPath.row == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath)
            if let aboutCell = cell as? AboutTableViewCell {
                aboutCell.arrowImage.image = #imageLiteral(resourceName: "arrowDown")
                aboutCell.titleLabel.text = "Sobre o Desligaí!"
                aboutCell.aboutLabel.text = "O Desligaí! surgiu no projeto do curso presencial do HackaTruck Maker Space e tem como objetivo monitorar o consumo de energia dos equipamentos elétricos da casa e ajudar a reduzir os gastos com energia.\nNossa equipe é composta por cinco integrantes: Alícia Reis, Douglas Tavares, Matheus Branco, Miriane Silva e Paulo Matheus.\n"
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        }

        return cell
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            if let currentLocation = locations.last, let addressCell = self.selectedCell as? AddressTableViewCell {
                if (addressCell.homeLocation == nil) {
                    addressCell.homeLocation = CLLocation()
                    addressCell.homeLocation = currentLocation
                    self.makeAddress()
                }
            }
        }
    }
    
    func makeAddress() {
        if let addressCell = self.selectedCell as? AddressTableViewCell {
            geocoder.reverseGeocodeLocation(addressCell.homeLocation!, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    if let address = firstLocation?.thoroughfare, let number = firstLocation?.subThoroughfare, let city = firstLocation?.locality, let locality = firstLocation?.subLocality, let administrativeArea = firstLocation?.administrativeArea, let postalcode = firstLocation?.postalCode {
                        addressCell.addressTextField.text = address
                        addressCell.numberTextField.text = number
                        addressCell.cityTextField.text = city
                        addressCell.localityTextField.text = locality
                        addressCell.admAreaTextField.text = administrativeArea
                        addressCell.postalcodeTextField.text = postalcode
                    }
                } else {
                    print(error.debugDescription)
                }
            })
        }
    }
    
    func makeBoldText(_ question: String, _ answer: String) -> NSMutableAttributedString {
        let boldText  = "\(question)\n"
        let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        let normalText = "\(answer)"
        let normalString = NSMutableAttributedString(string:normalText)
        
        attributedString.append(normalString)
        return attributedString
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
