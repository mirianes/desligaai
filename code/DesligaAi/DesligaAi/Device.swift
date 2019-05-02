//
//  Device.swift
//  DesligaAi
//
//  Created by Miriane Silva on 30/04/19.
//  Copyright © 2019 desligaAi. All rights reserved.
//

import Foundation

class Device {
    
    let id: String //aqui armazena o valor do QRCode
    let equipamentName: String //a qual equipamento está conectado
    let name: String
    let autoOff: Bool
    let state: Bool
    let idUser: String
    let consumption: String
    let consumptionDay: [String]
    let consumptionMonth: [String]
    let photoImage: String
    
    init(_ json: [String: Any]) {
        self.id = json["id"] as? String ?? ""
        self.equipamentName = json["equipament"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.autoOff = json["autoOff"] as? Bool ?? false
        self.state = json["state"] as? Bool ?? false
        self.idUser = json["idUser"] as? String ?? ""
        self.consumption = json["consumption"] as? String ?? "0"
        self.consumptionDay = json["consumptionDay"] as? [String] ?? []
        self.consumptionMonth = json["consumptionMonth"] as? [String] ?? []
        
        if self.state == true{
            self.photoImage = "DeviceLigado"
        } else {
            self.photoImage = "DeviceDesligado"
        }
    }
}

class DeviceCRUD {
    static func createDevice(_ body: [String: Any], _ callback: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: "\(databaseEndpoint)/desligaAi/device") else {
            print("Error in constructing URL in device create function")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print("Error in device create function: \(error.localizedDescription)")
        }
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let request = URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            guard error == nil else {
                print("Error in device create function: \(String(describing: error))")
                return
            }
            
            let responseString = String(data: data!, encoding: String.Encoding.utf8)
            if let check = responseString {
                callback(Bool(check)!)
            }
            
        })
        
        request.resume()
    }
}
