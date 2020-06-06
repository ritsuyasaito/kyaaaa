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
import FirebaseAuth

class SigninViewController: UIViewController, LoginButtonDelegate{
  
//    @IBOutlet var GoogleButton:GIDSignInButton!
    @IBOutlet var kyaaaaImageView: UIView!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var signInButton: UIButton!
    
    @IBOutlet weak var loginBaseView: LoginBaseView2!
    let fbLoginButton: FBLoginButton = FBLoginButton()
    
    var displayName = String()
    var pictureURL = String()
    var pictureURLString = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        fbLoginButton.delegate = self
//        　fbLoginButton.frame = CGRect(x: view.frame.size.width / 2 - view.frame.size.width / 4, y: view.frame.size.height / 4, width: view.frame.size.width / 2, height: 660)
        
      

    //fbLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true


        fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
        kyaaaaImageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        loginBaseView.translatesAutoresizingMaskIntoConstraints = false

        //許可するもの
        fbLoginButton.permissions = ["public_profile, email"]
        view.addSubview(fbLoginButton)
        
        // AutolayOut
        kyaaaaImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        kyaaaaImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        kyaaaaImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        kyaaaaImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
         //---------------
        textLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -70).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        textLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.50).isActive = true
        textLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        //---------------
        signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 65).isActive = true
        signInButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        signInButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true
        signInButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        //---------------
        signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: self.signInButton.topAnchor, constant: -5).isActive = true
        //signUpButton.topAnchor.constraint(equalTo: self.loginBaseView.bottomAnchor, constant: 5).isActive = true
        signUpButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85).isActive = true
        signUpButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.08).isActive = true
        
        //---------------
        loginBaseView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginBaseView.bottomAnchor.constraint(equalTo: self.signUpButton.topAnchor, constant: -5).isActive = true
        loginBaseView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85).isActive = true
        loginBaseView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.08).isActive = true
        
        
        //---------------
       // fbLoginButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 100).isActive = true
        fbLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
      

        fbLoginButton.bottomAnchor.constraint(equalTo: self.loginBaseView.topAnchor, constant: -5).isActive = true
        fbLoginButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85).isActive = true
//
        fbLoginButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.08).isActive = true
        

        
        // 半透明の指定（デフォルト値）
        self.navigationController?.navigationBar.isTranslucent = true
        // 空の背景画像設定
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // ナビゲーションバーの影画像（境界線の画像）を空に設定
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.white
        ]


    }
    
    
//    //googleログイン
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//      // ...
//        
//      if let error = error {
//        self.delegate?.loginBaseView(failedBy: .google)
//                
//        return
//      }
//
//      guard let authentication = user.authentication else { return }
//      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                        accessToken: authentication.accessToken)
//      // ...
//    }
    
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
            
            var user = result?.user
            // Firestoreのデータベースを取得
                              let db = Firestore.firestore()
                              // データベースのpostsパスに対して投稿データを追加し保存
                              
            db.collection("users").document(user!.uid).setData([
                                  "displayName" : "",
                                  "photoURL" : "",
                                  "age" : "",
                                  "gender" : "",
                                  
                             
                              ]) { error in
                                  // 処理が終了したらcompletionブロックにerrorを返す.errorがnilなら成功
                               
                              }
               
               let ud = UserDefaults.standard
               //ログイン状態の保持
               ud.set(true, forKey: "isLogin")
               ud.synchronize()
//               ud.set(self.pictureURLString, forKey: "pictureURLString")
               
               let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
               let rootViewController = storyboard.instantiateViewController(withIdentifier: "First")
               UIApplication.shared.keyWindow?.rootViewController = rootViewController
               
           }
           
       }
       
       func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
           
       }
      

}


extension SigninViewController: LoginBaseViewDelegate {
    func loginBaseView(succeededBy type: LoginType) {
        switch type {
        case .firebase:
            print("Success FireBase")
        case .google:
            print("Success Google Login")

        }
        //ログイン成功
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "First")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController

        //ログイン状態の保持
        let ud = UserDefaults.standard
        ud.set(true, forKey: "isLogin")
        ud.synchronize()
    }

    func loginBaseView(failedBy type: LoginType) {
        switch type {
        case .firebase:
            print("Failed FireBase")
        case .google:
            print("Failed Google Login")

        }
    }
}


