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
import FirebaseAuth
import Firebase

class UserPageViewController: UIViewController {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userAgeLabel: UILabel!
    @IBOutlet var userGenderLabel: UILabel!
    
    let currentUser = Auth.auth().currentUser
    var user = UserModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
    }
    
    func getUserData() {
        // Firestoreのデータベースを取得
        let db = Firestore.firestore()
        if currentUser != nil {
            let docRef = db.collection("users").document(currentUser!.uid)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() as! [String:Any]
                    if dataDescription["displayName"] != nil {
                        self.userNameLabel.text = dataDescription["displayName"] as? String
                    } else {
                        self.userNameLabel.text = "No Name"
                    }
                    if dataDescription["age"] != nil {
                        self.userAgeLabel.text = dataDescription["age"] as? String
                    } else {
                        self.userAgeLabel.text = "未入力"
                    }
                    if dataDescription["gender"] != nil {
                        self.userGenderLabel.text = dataDescription["gender"] as? String
                    } else {
                        self.userGenderLabel.text = "未入力"
                    }
                    if let imageURL = dataDescription["photoURL"] as! String? {
                        let url = URL(string: imageURL)
                        if url != nil {
                            do {
                                let data = try Data(contentsOf: url!)
                                self.userImageView.image = UIImage(data: data)
                            } catch let err {
                                print("Error : \(err.localizedDescription)")
                            }
                            
                        } else {
                            self.userImageView.image = UIImage(named: "male-placeHolder.jpg")
                        }
                    } else {
                        self.userImageView.image = UIImage(named: "male-placeHolder.jpg")
                    }
                }
            }
        }
        
    }
    
    
    
    @IBAction func didTapEditButton() {
        performSegue(withIdentifier: "toEdit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEdit" {
            let EditUserVC = segue.destination as! EditUserProfileViewController
            //EditUserVC.uesrImageView.image = userImageView.image
//            EditUserVC.userGenderTextField.text = userGenderLabel.text
//            EditUserVC.userAgeTextField.text = userAgeLabel.text
//            EditUserVC.userNameTextField.text = userNameLabel.text
        }
        
    }

   

}
