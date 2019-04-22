//
//  User.swift
//  DesligaAi
//
//  Created by Miriane Silva on 20/04/2019.
//  Copyright © 2019 DesligaAi. All rights reserved.
//

import Foundation

class User {
    var name: String
    var email: String
    var password: String
    
    init(_ json: [String: AnyObject]) {
        self.name = json["name"] as? String ?? ""
        self.email = json["email"] as? String ?? ""
        self.password = json["password"] as? String ?? ""
    }
}

class UserCRUD {
    static func createUser(_ body: [String: String], _ callback: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: "\(databaseEndpoint)/desligaAi/user") else {
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
            
            let responseString = String(data: data!, encoding: String.Encoding.utf8)
            if let check = responseString {
                callback(Bool(check)!)
            }
            
        })
        
        request.resume()
    }
}
