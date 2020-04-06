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
import Firebase
import FirebaseAuth
import SCLAlertView



class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    var isFirstLogin: Bool = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let ud = UserDefaults.standard
        let isFirst = ud.bool(forKey: "isFirstLogin")
        
        if isFirstLogin == true {
            ud.set(true, forKey: "isFirstLogin")
        } else {
            ud.set(true, forKey: "isFirstLogin")
        }
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func login() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let ud = UserDefaults.standard
        let isFirst = ud.bool(forKey: "isFirstLogin")
        
        if isFirstLogin == true || isFirst == true {
            UserModel.signUp2(email: email, password: password) { (error) in
                if let error = error {
                    print(error)
                    
                    let view = MessageView.viewFromNib(layout: .messageView)
                    view.configureTheme(.error)
                    view.button?.isHidden = true
                    view.titleLabel?.text = "エラー"
                    view.bodyLabel?.text = "有効でないメールアドレスか、パスワードが異なります。"
                    SwiftMessages.show(view: view)
                } else {
                    if Auth.auth().currentUser != nil{
                        Auth.auth().currentUser?.reload(completion: { (error) in
                            if error == nil{
                                if Auth.auth().currentUser?.isEmailVerified == true{
                                    HUD.flash(.success, delay: 1.0)
                                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "First")
                                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                                    
                                    //ログイン状態の保持
                                    let ud = UserDefaults.standard
                                    ud.set(true, forKey: "isLogin")
                                    ud.set(false, forKey: "isFirstLogin")
                                
                                    ud.synchronize()
                                }else if Auth.auth().currentUser?.isEmailVerified == false{
                                    let appearance = SCLAlertView.SCLAppearance(
                                        showCloseButton: false
                                    )
                                    let alert = SCLAlertView(appearance: appearance)
                                    alert.addButton("はい") {
                                        
                                        
                                    }
                                    
                                    alert.showInfo("", subTitle: "メール認証を行ってください")
                                }
                            }
                        })
                    }
                    
                }
            }
            
        } else {
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
                    if Auth.auth().currentUser != nil{
                        Auth.auth().currentUser?.reload(completion: { (error) in
                            if error == nil{
                                if Auth.auth().currentUser?.isEmailVerified == true{
                                    HUD.flash(.success, delay: 1.0)
                                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "First")
                                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                                    
                                    //ログイン状態の保持
                                    let ud = UserDefaults.standard
                                    ud.set(true, forKey: "isLogin")
                                   
                                    ud.synchronize()
                                }else if Auth.auth().currentUser?.isEmailVerified == false{
                                    let appearance = SCLAlertView.SCLAppearance(
                                        showCloseButton: false
                                    )
                                    let alert = SCLAlertView(appearance: appearance)
                                    alert.addButton("はい") {
                                        
                                        
                                    }
                                    
                                    alert.showInfo("", subTitle: "メール認証を行ってください")
                                }
                            }
                        })
                    }
                    
                }
            }
        }
        
        
        
        
        
        
    }   
    
    
    
}
