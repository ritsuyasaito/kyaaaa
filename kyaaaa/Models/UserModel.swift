//
//  UserModel.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/02/25.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseAnalytics
import GoogleSignIn
// ユーザーを扱いやすくするモデルクラス(設計図)を作成
struct UserModel {
    // ユーザーの設計
    var uid: String! // 各ユーザーごとの固有のID
    var email: String? // メールアドレス
    var displayName: String? // 表示名
    var photoURL: String? // 画像のURL
    var age: String?
    var gender: String?
    
    
    
    
    
    func editProfile(completion: @escaping(Error?) -> ()) {
       
        
        
        // Firestoreのデータベースを取得
       
        
        let db = Firestore.firestore()
        // データベースのpostsパスに対して投稿データを追加し保存
        
        db.collection("users").document(uid).updateData([
            "displayName" : displayName,
            "photoURL" : photoURL,
            "age" : age,
            "gender": gender,
            
       
        ]) { error in
            // 処理が終了したらcompletionブロックにerrorを返す.errorがnilなら成功
            completion(error)
        }
         
       
    }
    
    //ログイン中のユーザーをDBから取得するメソッド
    
    static func getCurrentUser() -> UserModel? {
        if let currentUserId = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            var currentUser = UserModel()
            let docRef = db.collection("users").document(currentUserId)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    var currentUser = UserModel()
                    currentUser.uid = currentUserId
                    currentUser.displayName = data?["displayName"] as! String
                    currentUser.photoURL = data!["photoURL"] as? String
                    currentUser.age = data!["age"] as? String
                    currentUser.gender = data!["gender"] as? String
                    
                    
                } else {
                    print("Document does not exist")
                   
                }
            }
            
            return currentUser
        } else {
            return nil
        }
    }

       
    
       // ログイン中のユーザーを取得するメソッド
       static func currentUser() -> UserModel? {
           if let currentUser = Auth.auth().currentUser {
               var user = UserModel()
               user.uid = currentUser.uid
               user.email = currentUser.email
               user.displayName = currentUser.displayName
               
               return user
           } else {
               return nil
           }
       }
       
       // ログイン中のユーザーがいるかどうか確認し、ログインしていなければログイン画面に飛ばすメソッド

       
       // 会員登録
       static func signUp(email: String, password: String, completion: @escaping(Error?) -> ()) {
           Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(error)
            if error == nil {
                let currentUser = Auth.auth().currentUser
                
                var user = UserModel()
                user.uid = currentUser?.uid
                user.email = currentUser?.email
                // Firestoreのデータベースを取得
                 let db = Firestore.firestore()
                 // データベースのpostsパスに対して投稿データを追加し保存
                 
                db.collection("users").document(user.uid).setData([
                     "displayName" : "",
                     "photoURL" : "",
                     "age" : "",
                     "gender" : "",
                     
                
                 ]) { error in
                     // 処理が終了したらcompletionブロックにerrorを返す.errorがnilなら成功
                     completion(error)
                 }
                
            }
             
           }
        
        
        
       }
    
    
    
 
    
    
       
       // ログイン
       static func login(email: String, password: String, completion: @escaping(Error?) -> ()) {
           Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
               completion(error)
           }
       }
       
       // ログアウト
       static func logout(completion: @escaping(Error?) -> ()) {
           do {
               try Auth.auth().signOut()
           } catch let error {
            print("ログアウトに失敗")
            completion(error)
           }
       }
    
    
    
    //プロフィール画像のUpload
    static func save(imageData: Data, completion: @escaping(_ url: URL?, _ error: Error?) -> ()) {
        guard let userId = UserModel.currentUser()?.uid else {
            completion(nil, nil)
            return
        }
        //let fileName = Date().description
        let storageRef = Storage.storage().reference().child("\(userId)/.png")
        let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            // let size = metadata.size
            storageRef.downloadURL { (url, error) in
                completion(url, error)
            }
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print(percentComplete)
        }
    }
       
    
}
