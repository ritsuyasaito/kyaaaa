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
import BubbleTransition


class PostViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ageArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ageTextField.text = ageArray[row]
    }
    
    
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var initialTextField: UITextField!
    @IBOutlet var postTextView: UITextView!
    
    var fromGender: String?
    var collection = "MailPosts"
    var users = [UserModel]()
    
    
    var ageArray = ["","小学生","中学生","高校生","大学生","社会人"]
    var pickerView1: UIPickerView = UIPickerView()
    
    var currentUser = Auth.auth().currentUser
    
    var userPhotoURL: String?
    var userName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ageTextField.delegate = self
        initialTextField.delegate = self
        
        pickerView1.delegate = self
        pickerView1.dataSource = self
        
        
        
        let toolbar1 = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem1 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EditUserProfileViewController.done1))
        let cancelItem1 = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EditUserProfileViewController.cancel1))
        toolbar1.setItems([cancelItem1, doneItem1], animated: true)
        
        self.ageTextField.inputView = pickerView1
        self.ageTextField.inputAccessoryView = toolbar1
        
        // Do any additional setup after loading the view.
        
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc func cancel1() {
        self.ageTextField.endEditing(true)
    }
    
    @objc func done1() {
        self.ageTextField.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if fromGender == "男性から" {
            collection = "Mailposts"
        } else {
            collection = "Femailposts"
        }
        
        loadUserData()
    }
    
    @IBAction func post() {
        var post = Post()
        
//        if userName == nil{
//            let alert = UIAlertController(title: "投稿にはユーザーネームが必要です", message: "入力して下さい", preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
//                    alert.dismiss(animated: true, completion: nil)
//                }
//            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
//                alert.dismiss(animated: true, completion: nil)
//
//            }
//
//            alert.addAction(cancelAction)
//            alert.addAction(okAction)
//            alert.addTextField { (textField) in
//                textField.placeholder = "ここに入力"
//            }
//            self.present(alert, animated: true, completion: nil)
            //保存のコード
//        }else{
            if ageTextField.text == "" || postTextView.text == ""{
                  let alertText = "宛先または投稿文が未入力です。"
                  let alertController = UIAlertController(title: "エラー", message: alertText, preferredStyle: .alert)
                  let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                  })
                  alertController.addAction(okAction)
                  self.present(alertController, animated: true, completion: nil)
              }else{
                 
                  post.age = ageTextField.text!
                  post.initial = initialTextField.text!
                  post.text = postTextView.text!
                  post.userId = currentUser?.uid
                if post.userName != nil{
                     post.userName = userName
                }else{
                    post.userName = "名無し"
                }
                 
                
                  post.userPhotoURL = userPhotoURL
                  
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
//        }
        
  
        
        
    }
    
    func loadUserData() {
        // Firestoreのデータベースを取得
        let db = Firestore.firestore()
        if currentUser != nil {
            let docRef = db.collection("users").document(currentUser!.uid)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() as! [String:Any]
                    if let userName = dataDescription["displayName"] as! String? {
                        self.userName = userName
                    } else {
                        self.userName = "NoData"
                    }
                    
                    if let imageURL = dataDescription["userPhotoURL"] as! String? {
                        self.userPhotoURL = imageURL
                    } else {
                        self.userPhotoURL = ""
                    }
                }
            }
        }
    }
    
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
