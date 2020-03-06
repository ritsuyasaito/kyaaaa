//
//  Post.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/02/29.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import Firebase

struct Post {
    // 1つの投稿の設計
    var uid: String! // 投稿ごとのユニークなID
    var userId: String! // 投稿したユーザーのID
  
    var createdAt: String! // 投稿した日時
    
    var userPhotoURL: String?
    var age: String?
    var initial: String?
    
    var text: String? // 投稿に付加したテキスト
    var naruhodoUsers: [String]? // 投稿にいいねしたユーザーId一覧
    var sorenaUsers: [String]? // 投稿にいいねしたユーザーId一覧
    var kyaaaaUsers: [String]? // 投稿にkyaaaaしたユーザーId一覧
    var isGood: Bool = false
    var isSorena: Bool = false
    var isKyaaaa: Bool = false
    

    
    // 投稿をDBに保存
    func save(collection: String, completion: @escaping(Error?) -> ()) {
        // ログインしているユーザー、テキストの記入、写真の設定がない場合、投稿できずreturnするようにしている
        guard let userId = UserModel.currentUser()?.uid else { return }
        
        guard let text = self.text else { return }
        
        //guard let userPhotoURL = self.userPhotoURL else { return }
        
        guard let age = self.age else {
            return
        }
        guard let initial = self.initial else {
            return
        }
        guard let userPhotoURL = self.userPhotoURL else {
            
            return
        }
        //guard let user = self.user else { return }
        // Firestoreのデータベースを取得
        let db = Firestore.firestore()
        
        // データベースのpostsパスに対して投稿データを追加し保存
        db.collection(collection).addDocument(data: [
            
            "text": text,
            "age" : age,
            "initial" : initial,
            "userId": userId,
            "userPhotoURL": userPhotoURL,
            //"user": user,
            "createdAt": String(Date().timeIntervalSince1970)
        ]) { error in
            // 処理が終了したらcompletionブロックにerrorを返す.errorがnilなら成功
            completion(error)
        }
    }
    

    
    // DBから投稿を取得
    static func getAll(collection: String, isAdditional: Bool = false, lastSnapshot: DocumentSnapshot? = nil, completion: @escaping(_ posts: [Post]?, _ lastSnapshot: DocumentSnapshot?, _ error: Error?) -> ()) {
        // データベースへの参照を作る
        let ref = Firestore.firestore().collection(collection)
        
        // タイムラインは新しい投稿が上にくるので降順にし、50件ずつ取得するクエリを作成
        var query = ref.order(by: "createdAt", descending: true).limit(to: 50)
        
         
        
        // 下に引っ張って読み込み(追加読み込み)の操作のときは、前回読み込んだ最後の投稿を基準に読み込むクエリを作成
        if isAdditional == true {
            guard let lastSnapshot = lastSnapshot else {
                completion(nil, nil, nil)
                return
            }
            query = query.start(afterDocument: lastSnapshot)
        }
        
        // クエリの読み込み
        query.getDocuments { (snapshot, error) in
            if let error = error {
                // 取得時にエラーが発生した場合errorをcompletionブロックに返す
                completion(nil, nil, error)
            } else {
                // 読み込んだsnapshotのデータをPostクラスの配列に変換
                if let documents = snapshot?.documents {
                    var posts = [Post]()
                    for document in documents {
                        let data = document.data()
                        var post = Post()
                        post.uid = document.documentID
                        post.userId = data["userId"] as? String
                        post.createdAt = data["createdAt"] as? String
                        post.age = data["age"] as? String
                        post.initial = data["initial"] as? String
                    
                        post.text = data["text"] as? String
                        post.userPhotoURL = data["userPhotoURL"] as? String
                        
                        post.naruhodoUsers = data["naruhodoUsers"] as? [String]
                        post.sorenaUsers = data["sorenaUsers"] as? [String]
                        post.kyaaaaUsers = data["kyaaaaUsers"] as? [String]
                        posts.append(post)
                    }
                    
                    // 追加読み込みのため、1度読み込んだらその最後の投稿データを変数に格納しておく
                    let lastSnapshot = documents.last
                    
                    // 処理完了とともにPostクラスの配列と最後の投稿データをcompletionブロックに返す
                    completion(posts, lastSnapshot, nil)
                } else {
                    // エラーもないが取得できるsnapshotがなかった場合
                    completion(nil, nil, nil)
                }
            }
        }
    }
    
    // DBからフィルターがかかった投稿を取得
    static func getAgeData(age: String, collection: String, isAdditional: Bool = false, lastSnapshot: DocumentSnapshot? = nil, completion: @escaping(_ posts: [Post]?, _ lastSnapshot: DocumentSnapshot?, _ error: Error?) -> ()) {
        // データベースへの参照を作る
        let ref = Firestore.firestore().collection(collection)
        
        // タイムラインは新しい投稿が上にくるので降順にし、50件ずつ取得するクエリを作成
        
        var query = ref.whereField("age", isEqualTo: age)
        query = query.order(by: "createdAt", descending: true).limit(to: 50)
        
         
        
        // 下に引っ張って読み込み(追加読み込み)の操作のときは、前回読み込んだ最後の投稿を基準に読み込むクエリを作成
        if isAdditional == true {
            guard let lastSnapshot = lastSnapshot else {
                completion(nil, nil, nil)
                return
            }
            query = query.start(afterDocument: lastSnapshot)
        }
        
        // クエリの読み込み
        query.getDocuments { (snapshot, error) in
            if let error = error {
                // 取得時にエラーが発生した場合errorをcompletionブロックに返す
                completion(nil, nil, error)
            } else {
                // 読み込んだsnapshotのデータをPostクラスの配列に変換
                if let documents = snapshot?.documents {
                    var posts = [Post]()
                    for document in documents {
                        let data = document.data()
                        var post = Post()
                        post.uid = document.documentID
                        post.userId = data["userId"] as? String
                        post.createdAt = data["createdAt"] as? String
                        post.age = data["age"] as? String
                        post.initial = data["initial"] as? String
                    
                        post.text = data["text"] as? String
                        post.userPhotoURL = data["userPhotoURL"] as? String
                        
                        post.naruhodoUsers = data["naruhodoUsers"] as? [String]
                        post.sorenaUsers = data["sorenaUsers"] as? [String]
                        post.kyaaaaUsers = data["kyaaaaUsers"] as? [String]
                        posts.append(post)
                    }
                    
                    // 追加読み込みのため、1度読み込んだらその最後の投稿データを変数に格納しておく
                    let lastSnapshot = documents.last
                    
                    // 処理完了とともにPostクラスの配列と最後の投稿データをcompletionブロックに返す
                    completion(posts, lastSnapshot, nil)
                } else {
                    // エラーもないが取得できるsnapshotがなかった場合
                    completion(nil, nil, nil)
                }
            }
        }
    }
    
    
    // DBからUserの投稿を取得
    static func getUserPost(collection: String, userId: String, isAdditional: Bool = false, lastSnapshot: DocumentSnapshot? = nil, completion: @escaping(_ posts: [Post]?, _ lastSnapshot: DocumentSnapshot?, _ error: Error?) -> ()) {
        // データベースへの参照を作る
        let ref = Firestore.firestore().collection(collection)
        
        // タイムラインは新しい投稿が上にくるので降順にし、50件ずつ取得するクエリを作成
        var query = ref.whereField("userId", isEqualTo: userId)
        query = query.order(by: "createdAt", descending: true).limit(to: 50)
        
        // 下に引っ張って読み込み(追加読み込み)の操作のときは、前回読み込んだ最後の投稿を基準に読み込むクエリを作成
        if isAdditional == true {
            guard let lastSnapshot = lastSnapshot else {
                completion(nil, nil, nil)
                return
            }
            query = query.start(afterDocument: lastSnapshot)
        }
        // クエリの読み込み
        query.getDocuments { (snapshot, error) in
            if let error = error {
                // 取得時にエラーが発生した場合errorをcompletionブロックに返す
                completion(nil, nil, error)
            } else {
                // 読み込んだsnapshotのデータをPostクラスの配列に変換
                if let documents = snapshot?.documents {
                    var posts = [Post]()
                    for document in documents {
                        let data = document.data()
                        var post = Post()
                        post.uid = document.documentID
                        post.userId = data["userId"] as? String
                        post.createdAt = data["createdAt"] as? String
                        post.age = data["age"] as? String
                        post.initial = data["initial"] as? String
                    
                        post.text = data["text"] as? String
                        post.userPhotoURL = data["userPhotoURL"] as? String
                        
                        post.naruhodoUsers = data["naruhodoUsers"] as? [String]
                        post.sorenaUsers = data["sorenaUsers"] as? [String]
                        post.kyaaaaUsers = data["kyaaaaUsers"] as? [String]
                        posts.append(post)
                    }
                    
                    // 追加読み込みのため、1度読み込んだらその最後の投稿データを変数に格納しておく
                    let lastSnapshot = documents.last
                    
                    // 処理完了とともにPostクラスの配列と最後の投稿データをcompletionブロックに返す
                    completion(posts, lastSnapshot, nil)
                } else {
                    // エラーもないが取得できるsnapshotがなかった場合
                    completion(nil, nil, nil)
                }
            }
        }
    }
    
    // DBから投稿を取得
    static func getUserkyaaaPost(collection: String, userId: String, isAdditional: Bool = false, lastSnapshot: DocumentSnapshot? = nil, completion: @escaping(_ posts: [Post]?, _ lastSnapshot: DocumentSnapshot?, _ error: Error?) -> ()) {
        // データベースへの参照を作る
        let ref = Firestore.firestore().collection(collection)
        
        // タイムラインは新しい投稿が上にくるので降順にし、50件ずつ取得するクエリを作成
        var query = ref.whereField("kyaaaaUsers", arrayContains: userId)
        query = query.order(by: "createdAt", descending: true).limit(to: 50)
        
        // 下に引っ張って読み込み(追加読み込み)の操作のときは、前回読み込んだ最後の投稿を基準に読み込むクエリを作成
        if isAdditional == true {
            guard let lastSnapshot = lastSnapshot else {
                completion(nil, nil, nil)
                return
            }
            query = query.start(afterDocument: lastSnapshot)
        }
        // クエリの読み込み
        query.getDocuments { (snapshot, error) in
            if let error = error {
                // 取得時にエラーが発生した場合errorをcompletionブロックに返す
                completion(nil, nil, error)
                
            } else {
                // 読み込んだsnapshotのデータをPostクラスの配列に変換
                if let documents = snapshot?.documents {
                    var posts = [Post]()
                    for document in documents {
                        let data = document.data()
                        var post = Post()
                        post.uid = document.documentID
                        post.userId = data["userId"] as? String
                        post.createdAt = data["createdAt"] as? String
                        post.age = data["age"] as? String
                        post.initial = data["initial"] as? String
                    
                        post.text = data["text"] as? String
                        post.userPhotoURL = data["userPhotoURL"] as? String
                        
                        post.naruhodoUsers = data["naruhodoUsers"] as? [String]
                        post.sorenaUsers = data["sorenaUsers"] as? [String]
                        post.kyaaaaUsers = data["kyaaaaUsers"] as? [String]
                        posts.append(post)
                    }
                    
                    // 追加読み込みのため、1度読み込んだらその最後の投稿データを変数に格納しておく
                    let lastSnapshot = documents.last
                    
                    // 処理完了とともにPostクラスの配列と最後の投稿データをcompletionブロックに返す
                    completion(posts, lastSnapshot, nil)
                } else {
                    // エラーもないが取得できるsnapshotがなかった場合
                    completion(nil, nil, nil)
                }
            }
        }
    }
    
    func kyaaaa(collection: String, completion: @escaping(Error?) -> ()) {
        guard let userId = UserModel.currentUser()?.uid else { return }
        if self.kyaaaaUsers?.contains(userId) == true {
            // いいねを解除
            guard let postId = self.uid else { return }
            guard let currentUserId = UserModel.currentUser()?.uid else { return }
            let db = Firestore.firestore()
            db.document("\(collection)/\(postId)").updateData(["kyaaaaUsers": FieldValue.arrayRemove([currentUserId])]) { (error) in
                completion(error)
            }
        } else {
            // いいね
            guard let postId = self.uid else { return }
            guard let currentUserId = UserModel.currentUser()?.uid else { return }
            let db = Firestore.firestore()
            db.document("\(collection)/\(postId)").updateData(["kyaaaaUsers": FieldValue.arrayUnion([currentUserId])]) { (error) in
                completion(error)
            }
        }
        
    }
    
    func sorena(collection: String, completion: @escaping(Error?) -> ()) {
        guard let userId = UserModel.currentUser()?.uid else { return }
        if self.kyaaaaUsers?.contains(userId) == true {
            // いいねを解除
            guard let postId = self.uid else { return }
            guard let currentUserId = UserModel.currentUser()?.uid else { return }
            let db = Firestore.firestore()
            db.document("\(collection)/\(postId)").updateData(["sorenaUsers": FieldValue.arrayRemove([currentUserId])]) { (error) in
                completion(error)
            }
        } else {
            // いいね
            guard let postId = self.uid else { return }
            guard let currentUserId = UserModel.currentUser()?.uid else { return }
            let db = Firestore.firestore()
            db.document("\(collection)/\(postId)").updateData(["sorenaUsers": FieldValue.arrayUnion([currentUserId])]) { (error) in
                completion(error)
            }
        }
        
    }
    
    
    func naruhodo(collection: String, completion: @escaping(Error?) -> ()) {
        guard let userId = UserModel.currentUser()?.uid else { return }
        if self.kyaaaaUsers?.contains(userId) == true {
            // いいねを解除
            guard let postId = self.uid else { return }
            guard let currentUserId = UserModel.currentUser()?.uid else { return }
            let db = Firestore.firestore()
            db.document("\(collection)/\(postId)").updateData(["naruhodoUsers": FieldValue.arrayRemove([currentUserId])]) { (error) in
                completion(error)
            }
        } else {
            // いいね
            guard let postId = self.uid else { return }
            guard let currentUserId = UserModel.currentUser()?.uid else { return }
            let db = Firestore.firestore()
            db.document("\(collection)/\(postId)").updateData(["naruhodoUsers": FieldValue.arrayUnion([currentUserId])]) { (error) in
                completion(error)
            }
            
        }
        
    }
    
}

