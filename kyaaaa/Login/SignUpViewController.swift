//
//  SignUpViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/02/27.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import PKHUD
import SwiftMessages

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func signUp() {
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            
            HUD.flash(.success, delay: 1.0)
            UserModel.signUp(email: email, password: password) { (error) in
               
                if let error = error {
                  print(error)
                   
                  let view = MessageView.viewFromNib(layout: .messageView)
                  view.configureTheme(.error)
                  view.button?.isHidden = true
                  view.titleLabel?.text = "Error"
                  view.bodyLabel?.text = error.localizedDescription
                  SwiftMessages.show(view: view)
                } else {
                    HUD.show(.progress)
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                }
            }
        }
    
    

    
    

}
