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
        fbLoginButton.frame = CGRect(x: 32, y: 650, width: 351, height: 41)
    //fbLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true


        //許可するもの
        fbLoginButton.permissions = ["public_profile, email"]
        view.addSubview(fbLoginButton)
        
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


