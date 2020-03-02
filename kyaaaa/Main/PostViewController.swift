//
//  PostViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/02/29.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class PostViewController: UIViewController {
    
    @IBOutlet var ageaTextField: UITextField!
    @IBOutlet var initialTextField: UITextField!
    @IBOutlet var postTextView: UITextView!
    
    var fromGender: String?
    var collection = "MailPosts"
    
    var currentUser = Auth.auth().currentUser

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if fromGender == "男性から" {
            collection = "Mailposts"
        } else {
            collection = "Femailposts"
        }
    }
    
    @IBAction func post() {
        
        var post = Post()
        post.age = ageaTextField.text!
        post.initial = initialTextField.text!
        post.text = postTextView.text!
        post.userId = currentUser?.uid
        //post.userPhotoURL = currentUser?.photoURL
        
        post.save(collection: collection, completion: { (error) in
               DispatchQueue.main.async {
        //           SVProgressHUD.dismiss()
                   if let error = error {
                    print(error)
                    
                
                   //    self.showError(error: error)
                   } else {
               
           //            self.showSucsessAlert()
                        self.dismiss(animated: true, completion: nil)
                    
                   }
               }
        })
        self.dismiss(animated: true, completion: nil)
           
    }
    
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
    }
    

}
