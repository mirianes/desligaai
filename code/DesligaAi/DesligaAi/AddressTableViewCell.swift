//
//  AddressTableViewCell.swift
//  DesligaAi
//
//  Created by Miriane Silva on 01/05/2019.
//  Copyright © 2019 desligaAi. All rights reserved.
//

import UIKit
import MapKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var manualAddressStack: UIStackView!
    @IBOutlet weak var confirmAddressStack: UIStackView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var localityTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var admAreaTextField: UITextField!
    @IBOutlet weak var postalcodeTextField: UITextField!
    
    var homeLocation: CLLocation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func editAdress(_ sender: Any) {
        self.addressTextField.isEnabled = true
        self.numberTextField.isEnabled = true
        self.localityTextField.isEnabled = true
        self.cityTextField.isEnabled = true
        self.admAreaTextField.isEnabled = true
        self.postalcodeTextField.isEnabled = true
    }
    
    @IBAction func confirmAddress(_ sender: Any) {
        if self.addressTextField.isEnabled {
            let geocoder = CLGeocoder()
            let address = "\(String(describing: self.addressTextField.text!)), \(String(describing: self.numberTextField.text!)), \(String(describing: self.localityTextField.text!)), \(String(describing: self.cityTextField.text!)) - \(String(describing: self.admAreaTextField.text!)), \(String(describing: self.postalcodeTextField.text!)), Brazil"
            print(address)
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if error == nil {
                    self.homeLocation = placemarks?[0].location
                } else {
                    print(error.debugDescription)
                }
            })
        }
        self.endEditing(true)
        if let location = self.homeLocation {
            let body = ["adress": "\(location)", "mac": UIDevice.current.identifierForVendor!.uuidString] as [String : Any]
            DeviceCRUD.createDevice(body, { (status) in
                print(status)
            })
        }
    }
}
