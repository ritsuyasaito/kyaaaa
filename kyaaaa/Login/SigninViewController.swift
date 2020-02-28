//
//  SigninViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/02/27.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import GoogleSignIn

class SigninViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().presentingViewController = self
        

        // Do any additional setup after loading the view.
    }
    

}
