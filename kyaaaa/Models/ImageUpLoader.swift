//
//  ImageUpLoader.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/02/28.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import FirebaseStorage

struct ImageUploader {
    // 引数に渡された画像データをFirebaseのストレージに保存
    static func save(imageData: Data, completion: @escaping(_ url: URL?, _ error: Error?) -> ()) {
        guard let userId = UserModel.currentUser()?.uid else {
            completion(nil, nil)
            return
        }
        let fileName = Date().description
        let storageRef = Storage.storage().reference().child("\(userId)/\(fileName).png")
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
