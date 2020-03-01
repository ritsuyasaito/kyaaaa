//
//  EditUserProfileViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/02/28.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import FirebaseAuth
import PKHUD
import SwiftMessages
import Firebase
import FirebaseAuth


class EditUserProfileViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    @IBOutlet var uesrImageView: UIImageView!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var userAgeTextField: UITextField!
    @IBOutlet var userGenderTextField: UITextField!
    
    var pickerView1: UIPickerView = UIPickerView()
    var pickerView2: UIPickerView = UIPickerView()
    
    var genderArray = ["男","女"]
    var ageArray = ["中学生","高校生","19~22歳","23~29歳","30~40代","50代〜"]
    
  
    let currentUser = Auth.auth().currentUser
    

    override func viewDidLoad() {
        super.viewDidLoad()

        userGenderTextField.delegate = self
        userAgeTextField.delegate = self
        userGenderTextField.delegate = self
        
        pickerView1.delegate = self
        pickerView1.dataSource = self
        //pickerView1.showsSelectionIndicator = true
        pickerView2.delegate = self
        pickerView2.dataSource = self
        //pickerView2.showsSelectionIndicator = true
        
        let toolbar1 = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem1 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EditUserProfileViewController.done1))
        let cancelItem1 = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EditUserProfileViewController.cancel1))
        toolbar1.setItems([cancelItem1, doneItem1], animated: true)
    
        
        self.userGenderTextField.inputView = pickerView1
        self.userGenderTextField.inputAccessoryView = toolbar1
        
        let toolbar2 = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EditUserProfileViewController.done2))
        let cancelItem2 = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EditUserProfileViewController.cancel2))
        toolbar2.setItems([cancelItem2, doneItem2], animated: true)
        
        self.userAgeTextField.inputView = pickerView2
        self.userAgeTextField.inputAccessoryView = toolbar2
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerView1 {
            return genderArray.count
        } else if pickerView == pickerView2 {
            return ageArray.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView1 {
            return genderArray[row]
        } else if pickerView == pickerView2 {
            return ageArray[row]
        } else {
            return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1 {
            self.userGenderTextField.text = genderArray[row]
        } else if pickerView == pickerView2 {
            self.userAgeTextField.text = ageArray[row]
        }
    }

    @objc func cancel1() {
        self.userGenderTextField.endEditing(true)
    }
    
    @objc func cancel2() {
        self.userAgeTextField.endEditing(true)
    }

    @objc func done1() {
        self.userGenderTextField.endEditing(true)
    }
    
    @objc func done2() {
        self.userAgeTextField.endEditing(true)
    }

    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func selectImage() {
        let alertController = UIAlertController(title: "写真を選択", message: "投稿する写真を選択して下さい", preferredStyle: .alert)
        // for iPad
        alertController.popoverPresentationController?.sourceView = self.view
        //alertController.popoverPresentationController?.sourceRect = selectImageButton.frame
        
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            // camera
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        let photolibraryAction = UIAlertAction(title: "フォトライブラリから選択", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            // photolibrary
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(photolibraryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func saveProfile() {
        
        guard let data = uesrImageView.image?.pngData() else { return }
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = userNameTextField.text
        changeRequest?.commitChanges { (error) in
            if error != nil {
                print("errorが発生")
                print(error)
            }
            
        }
        
        UserModel.save(imageData: data) { (url, error) in
            if let error = error {
                HUD.flash(.error, delay: 1.0)
                print(error)
            } else {
                if let url = url {
                    var user = UserModel()
                    
                    user.displayName = self.userNameTextField.text
                    user.uid = self.currentUser?.uid
                    user.photoURL = url.absoluteString
                    user.age = self.userAgeTextField.text
                    user.gender = self.userGenderTextField.text
                    user.editProfile(completion: { (error) in
                           DispatchQueue.main.async {
                            HUD.show(.progress )
                    //           SVProgressHUD.dismiss()
                               if let error = error {
                                HUD.flash(.error, delay: 1.0)
                               } else {
                                HUD.flash(.success, delay: 0.5)
                                self.navigationController?.popViewController(animated: true)
                                self.dismiss(animated: true, completion: nil)
                               }
                           }
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                       
                } else {
                    print("画像を変更してください")
                }
                
            }
        }
        
        
    }
    
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
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
    
    func getUserData() {
        // Firestoreのデータベースを取得
        let db = Firestore.firestore()
        if currentUser != nil {
            let docRef = db.collection("users").document(currentUser!.uid)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() as! [String:Any]
                    if dataDescription["displayName"] != nil {
                        self.userNameTextField.text = dataDescription["displayName"] as? String
                    } else {
                        self.userNameTextField.text = "No Name"
                    }
                    if dataDescription["age"] != nil {
                        self.userAgeTextField.text = dataDescription["age"] as? String
                    } else {
                        self.userAgeTextField.text = "未入力"
                    }
                    if dataDescription["gender"] != nil {
                        self.userGenderTextField.text = dataDescription["gender"] as? String
                    } else {
                        self.userGenderTextField.text = "未入力"
                    }
                    if let imageURL = dataDescription["photoURL"] as! String? {
                        let url = URL(string: imageURL)
                        if url != nil {
                            do {
                                let data = try Data(contentsOf: url!)
                                self.uesrImageView.image = UIImage(data: data)
                            } catch let err {
                                print("Error : \(err.localizedDescription)")
                            }
                            
                        } else {
                            self.uesrImageView.image = UIImage(named: "male-placeHolder.jpg")
                        }
                    } else {
                        self.uesrImageView.image = UIImage(named: "male-placeHolder.jpg")
                    }
                }
            }
        }
        
    }

   

}

extension EditUserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage]
            as? UIImage {
            self.uesrImageView.image = pickedImage
            //self.selectImageButton.isHidden = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
