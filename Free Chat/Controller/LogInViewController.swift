//
//  LogInViewController.swift
//  Free Chat
//
//  Created by Talha on 06/03/2020.
//  Copyright © 2020 Talha. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
class LogInViewController: UIViewController {
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func logInPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextFeild.text!, password: passwordTextField.text!) { (user, error) in
             if error != nil {
                print(error ?? "Error")
                        }
                        else {
                self.performSegue(withIdentifier: "goToChat", sender: self)
                        }
        }
    }
}
