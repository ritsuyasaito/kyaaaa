//
//  LoginViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/02/27.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import PKHUD
import SwiftMessages



class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
       
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func login() {

        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        
        
        
        UserModel.login(email: email, password: password) { (error) in
            //SVProgressHUD.dismiss()
            if let error = error {
                print(error)
                
                let view = MessageView.viewFromNib(layout: .messageView)
                view.configureTheme(.error)
                view.button?.isHidden = true
                view.titleLabel?.text = "エラー"
                view.bodyLabel?.text = "有効でないメールアドレスか、パスワードが異なります。"
                SwiftMessages.show(view: view)
            } else {
                HUD.flash(.success, delay: 1.0)
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "First")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                
                //ログイン状態の保持
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud.synchronize()

   
            
        }
    }
    
   
    
    }   
    
    
    
}
