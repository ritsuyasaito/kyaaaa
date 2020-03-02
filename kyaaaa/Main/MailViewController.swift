//
//  MailViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/02/28.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import LocalAuthentication


//女子から男子へ、女子の投稿
class MailViewController: UIViewController {
    

   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // これを実行しないと context.biometryType が有効にならないので一度実行
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        state = .loggedout

        // Do any additional setup after loading the view.
    }
    
    
    
    
    //   ----------------パスワード要求ー---------------
    
    enum AuthenticationState {
        case loggedin, loggedout
    }
    var state: AuthenticationState = .loggedout {
        didSet {
      
        }
    }
    var context: LAContext = LAContext()
    
    @IBAction func didTabLoginButton(_ sender: Any) {
        
        guard state == .loggedout else {
            self.performSegue(withIdentifier: "toUserPage", sender: nil)
            state = .loggedout
            return
        }
        
        context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            
            let reason = "本人認証を行います"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        self.performSegue(withIdentifier: "toUserPage", sender: nil)
                        self.state = .loggedin
                    }
                } else if let laError = error as? LAError {
                    switch laError.code {
                    case .authenticationFailed:
                        break
                    case .userCancel:
                        break
                    case .userFallback:
                        break
                    case .systemCancel:
                        break
                    case .passcodeNotSet:
                        break
                    case .touchIDNotAvailable:
                        break
                    case .touchIDNotEnrolled:
                        break
                    case .touchIDLockout:
                        break
                    case .appCancel:
                        break
                    case .invalidContext:
                        break
                    case .notInteractive:
                        break
                    @unknown default:
                        break
                    }
                }
            }
        } else {
            // 生体認証ができない場合の認証画面表示など
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserPage" {
            
        }
    }
   

}
