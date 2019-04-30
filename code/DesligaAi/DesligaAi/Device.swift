//
//  Device.swift
//  DesligaAi
//
//  Created by student on 30/04/19.
//  Copyright © 2019 desligaAi. All rights reserved.
//

import Foundation

class Device {
    
    let equipTextField: String //a qual equipamento está conectado
    let idTextField: String //aqui armazena o valor do QRCode
    let estado: Bool
    let fotoImage: String
    
    
    init(_ json: [String: Any]) {
        self.equipTextField = json["equipamento"] as? String ?? ""
        self.idTextField = json["nome"] as? String ?? ""
        self.estado = json["estado"] as? Bool ?? false
        if estado == true{
            self.fotoImage = "DeviceLigado"
        }
        else{
            self.fotoImage = "DeviceDesligado"}
    }
}

class DeviceCRUD {
    static func createDevice(_ body: [String: String], _ callback: @escaping ((Bool) -> Void)) {
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
