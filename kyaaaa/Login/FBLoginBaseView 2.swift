//
//  FBLoginBaseView.swift
//  kyaaaa
//
//  Created by 藤田えりか on 2020/06/06.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import Firebase
import FirebaseAuth

protocol FBLoginBaseViewDelegate: class {
    func fBLoginBaseView(succeededBy type: FBLoginType)
    func fBLoginBaseView(failedBy type: FBLoginType)
}

enum FBLoginType {
    case firebase
    case facebook
}



class FBLoginBaseView: UIView, LoginButtonDelegate {
    weak var delegate: FBLoginBaseViewDelegate?
   // lazy var gidSignInButton:  = createGoogleButton()
    
    lazy var fbLoginButton: FBLoginButton = createFBLoginButton()
    
    var displayName = String()
    var pictureURL = String()
    var pictureURLString = String()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addLoginButtons()
        fbLoginButton.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addLoginButtons()
    }
    //    @available(iOS 9.0, *)
    //       func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    //           return
    //               GIDSignIn.sharedInstance().handle(
    //                   url,
    //                   sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
    //                   annotation: [:]
    //           )
    //       }
    
    //FBログイン
           func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            
            if let _ = error {
                self.delegate?.fBLoginBaseView(failedBy: .facebook)
                return
            }
           
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
   
    
          private func createFBLoginButton() -> FBLoginButton {
            
      
            //fbLoginButton.delegate = self
                 //          GIDSignIn.sharedInstance().uiDelegate = self これはまじで不明
                 
                 let button = FBLoginButton(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50))
                 return button
             }
   
           
    
   
    
    
    private func addLoginButtons() {
        // lazyなので、参照するタイミングでcreatexxxButton()が呼ばれる
        self.addSubview(fbLoginButton)
        
    }
    
    private func linkToFireBase(credential: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let _ = error {
                self.delegate?.fBLoginBaseView(failedBy: .firebase)
            }
            // ログイン成功
            self.delegate?.fBLoginBaseView(succeededBy: .firebase)
        }
    }
}


