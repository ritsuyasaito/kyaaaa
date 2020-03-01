//
//  LoginBaseView2.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/03/01.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import  Firebase
import  GoogleSignIn


protocol LoginBaseViewDelegate: class {
    func loginBaseView(succeededBy type: LoginType)
    func loginBaseView(failedBy type: LoginType)
}

enum LoginType {
    case firebase
    case google
    
}

class LoginBaseView2: UIView, GIDSignInDelegate {

    weak var delegate: LoginBaseViewDelegate?
     lazy var gidSignInButton: GIDSignInButton = createGoogleButton()
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         self.addLoginButtons()
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
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ログインエラーの場合(キャンセルも含む)
        if let _ = error {
            self.delegate?.loginBaseView(failedBy: .google)
            return
        }
        guard let authentication = user.authentication else {
            return
        }
        
      
        let credential =
            GoogleAuthProvider.credential(
                withIDToken: authentication.idToken,
                accessToken: authentication.accessToken
        )
        //ここからfirebase
           Auth.auth().signIn(with: credential) { (result, error) in
               if let error = error {
                   return
            }
              
            
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
              
               
               let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
               let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
               UIApplication.shared.keyWindow?.rootViewController = rootViewController
               
           }
        
        linkToFireBase(credential: credential)
        
        
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
         
        
      }
      
      func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
       
      }
    
    private func createGoogleButton() -> GIDSignInButton {
          GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
          GIDSignIn.sharedInstance().delegate = self
        
//          GIDSignIn.sharedInstance().uiDelegate = self これはまじで不明
 
          let button = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50))
          return button
      }
      
      
      
      private func addLoginButtons() {
          // lazyなので、参照するタイミングでcreatexxxButton()が呼ばれる
          self.addSubview(gidSignInButton)
          
      }
      
      private func linkToFireBase(credential: AuthCredential) {
          Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
              if let _ = error {
                  self.delegate?.loginBaseView(failedBy: .firebase)
              }
              // ログイン成功
              self.delegate?.loginBaseView(succeededBy: .firebase)
          }
      }

     
       
}

