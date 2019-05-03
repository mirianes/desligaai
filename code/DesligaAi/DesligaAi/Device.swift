//
//  Device.swift
//  DesligaAi
//
//  Created by Miriane Silva on 30/04/19.
//  Copyright © 2019 desligaAi. All rights reserved.
//

import Foundation

class Device {
    
    // 0 liga - 1 desliga { payload: 0/1 }
    
    var id: String //aqui armazena o valor do QRCode
    var equipamentName: String //a qual equipamento está conectado
    var name: String
    var autoOff: Bool
    var state: Bool
    var idUser: String
    var consumption: Double
    var consumptionDay: [String]
    var consumptionMonth: [String]
    var photoImage: String
    
    init(_ json: [String: Any]) {
        self.id = json["id"] as? String ?? ""
        self.equipamentName = json["equipament"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.autoOff = json["autoOff"] as? Bool ?? false
        self.state = json["state"] as? Bool ?? true
        self.idUser = json["idUser"] as? String ?? ""
        self.consumption = json["consumption"] as? Double ?? 0.0
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
        guard let url = URL(string: "\(databaseEndpoint)create") else {
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
    
    static func  listDevices(_ body: [String: Any], _ callback: @escaping (([Device]) -> Void)) {
        guard let url = URL(string: "\(databaseEndpoint)list") else {
            print("Error in constructing URL in user create function")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print("Error in user create function: \(error.localizedDescription)")
        }
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let request = URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            guard error == nil else {
                print("Error in user create function: \(String(describing: error))")
                return
            }
            var devices: [Device] = []
            
            DispatchQueue.main.async() {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]] {
                        for item in json{
                            
                            let device = Device(item)
                            devices.append(device)
                        }
                        callback(devices)
                    }
                } catch let error as NSError {
                    print("Error = \(error.localizedDescription)")
                }
            }
        })
        request.resume()
    }
    
    static func turnOffDevice(_ body: [String: Any], _ callback: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: "\(iotEndpoint)ligadesliga") else {
            print("Error in constructing URL in user create function")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print("Error in user create function: \(error.localizedDescription)")
        }
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let request = URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            guard error == nil else {
                print("Error in device create function: \(String(describing: error))")
                return
            }
            callback(true)
        })
        
        request.resume()
    }
    
    static func getConsumption(_ body: [String: Any], _ callback: @escaping ((String) -> Void)) {
        guard let url = URL(string: "\(iotEndpoint)recebe") else {
            print("Error in constructing URL in user create function")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
//        do {
//            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
//        } catch let error {
//            print("Error in user create function: \(error.localizedDescription)")
//        }
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let request = URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            guard error == nil else {
                print("Error in device create function: \(String(describing: error))")
                return
            }
            DispatchQueue.main.async() {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: AnyObject
                        ]] {
                        var consuption: String = ""
                        while (consuption == "") {
                            let number = Int.random(in: 0..<json.count)
                            if let disp = json[number]["d"], let consumoMedio = disp["consumoMedio"] {
                                if consumoMedio != nil {
                                    consuption = String(describing: consumoMedio)
                                }
                            }
                        }
                        
//                        for item in json {
//                            if let disp = item["d"], let consumoMedio = disp["consumoMedio"] {
//                                if consumoMedio != nil {
//                                    consuption = "\(String(describing: consumoMedio))"
//                                    break
//                                }
//                            }
//                        }
                        callback(consuption)
                    }
                } catch let error as NSError {
                    print("Error = \(error.localizedDescription)")
                }
            }
        })
        
        request.resume()
    }
}
