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


class EditUserProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var uesrImageView: UIImageView!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var userAgeTextField: UITextField!
    @IBOutlet var userGenderTextField: UITextField!
    
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()

        userGenderTextField.delegate = self
        userAgeTextField.delegate = self
        userGenderTextField.delegate = self
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
                    user.uid = self.user?.uid
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
