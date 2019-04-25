//
//  CadastroViewController.swift
//  DesligaAi
//
//  Created by Miriane Silva on 19/04/2019.
//  Copyright © 2019 DesligaAi. All rights reserved.
//

import UIKit

class CadastroViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func singup(_ sender: Any) {
    
        let name = nameTextField.text
        let email = emailTextField.text
        if (name != nil && email != nil && passwordTextField.text != nil) {
                let body = ["name": name, "email":email, "password": passwordTextField.text]
                UserCRUD.createUser(body as![String: String], {(status) in
                    if status {
                        self.singupSuccess()
                    }
                })
        }
    
    }

    
    func singupSuccess() {
        performSegue(withIdentifier: "singupSuccess", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
