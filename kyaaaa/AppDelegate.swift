//
//  AppDelegate.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/02/24.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import IQKeyboardManagerSwift
import FBSDKLoginKit
import FBSDKCoreKit
import FacebookLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate,LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
         if error == nil{
                      if result?.isCancelled == true{
                          //キャンセルされた場合は何もしないで返す
                          return
                      }
                  }
                  
                  let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
   
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
       
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //face.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
         // ...
         if let error = error {
           // ...
           return
         }

         guard let authentication = user.authentication else { return }
         let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
         // ...
       }
       func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
           // Perform any operations when the user disconnects from app here.
           // ...
       }
       
    
//    //追加(google)
//    @available(iOS 9.0, *)
//    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
//      -> Bool {    return GIDSignIn.sharedInstance().handle(url,
//                                sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                                annotation: [:])
//    }
    
   
    //追加
    func application(_ application : UIApplication,open url: URL, sourceApplication: String?, annotation: Any)->Bool{
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
    }

      //追加
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }
    
  

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

