//
//  UserPageViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/02/27.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import PKHUD
import SwiftMessages

class UserPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

     
        
    }
    
    @IBAction func logout() {
           // SVProgressHUD.show()
             
            UserModel.logout { (error)  in
                HUD.show(.progress)
            
                if let error = error {
                    HUD.show(.error)
                    print(error)
                } else {
                    // ログイン画面に移動
//                    let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
//                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
//                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
//
//                    // ログイン状態の保持
//                    let ud = UserDefaults.standard
//                    ud.set(false, forKey: "isLogin")
//                    ud.synchronize()
                   
                }
            }
        PKHUD.sharedHUD.contentView = PKHUDSuccessView()
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 2.0) { success in
            // Completion Handler
            let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            // ログイン状態の保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
        }
        
            
        
    }

   

}
