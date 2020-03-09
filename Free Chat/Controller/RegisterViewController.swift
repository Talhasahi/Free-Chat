//
//  RegisterViewController.swift
//  Free Chat
//
//  Created by Talha on 06/03/2020.
//  Copyright © 2020 Talha. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        //SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            // This is Complection Handler call when Response Come from Data Base
            if error != nil {
                print(error)
            }
            else {
                print("Registered")
                //SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
    
    
}
