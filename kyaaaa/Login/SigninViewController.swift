//
//  SigninViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/02/27.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import Firebase

class SigninViewController: UIViewController, LoginButtonDelegate {
    
    let fbLoginButton: FBLoginButton = FBLoginButton()
    var displayName = String()
    var pictureURL = String()
    var pictureURLString = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().presentingViewController = self
        
        fbLoginButton.delegate = self
//        fbLoginButton.frame = CGRect(x: view.frame.size.width / 2 - view.frame.size.width / 4, y: view.frame.size.height / 4, width: view.frame.size.width / 2, height: 660)
        fbLoginButton.frame = CGRect(x: 32, y: 650, width: 351, height: 41)
        
        //許可するもの
        fbLoginButton.permissions = ["public_profile, email"]

        view.addSubview(fbLoginButton)


        // Do any additional setup after loading the view.
    }
    //FBログイン
       func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
           //aigninする
           if error == nil{
               if result?.isCancelled == true{
                   //キャンセルされた場合は何もしないで返す
                   return
               }
           }
           
           let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
           
           //ここからfirebase
           Auth.auth().signIn(with: credential) { (result, error) in
               if let error = error {
                   return
               }
               self.displayName = (result?.user.displayName)!
               //string型に強制変換
               self.pictureURLString = (result?.user.photoURL!.absoluteString)!
               self.pictureURLString = self.pictureURLString + "?type=large"
               
               let ud = UserDefaults.standard
               //ログイン状態の保持
               ud.set(true, forKey: "isLogin")
               ud.synchronize()
               ud.set(self.pictureURLString, forKey: "pictureURLString")
               
               let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
               let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
               UIApplication.shared.keyWindow?.rootViewController = rootViewController
               
           }
           
           
           
       }
       
       func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
           
       }
       

}
