//
//  FemailKyaaaaViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/03/06.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import PKHUD
import SCLAlertView


class FemailKyaaaaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TimeLineTableViewCellDelegate {
    let currentUserId = Auth.auth().currentUser?.uid
    var gender = ""
    var userBlockIds = [String]()
    // 読み込み中かどうかを判別する変数(読み込み結果が0件の場合DZNEmptyDataSetで空の表示をさせるため)
    var isLoading: Bool = false
    
    // 下に引っ張って追加読み込みしたい場合に使う、読み込んだ投稿の最後の投稿を保存する変数
    var lastSnapshot: DocumentSnapshot?
    
    var posts = [Post]()
    var selectedPost: Post?
   
    let currentUser = Auth.auth().currentUser
    
    @IBOutlet var femaleKyaaaaDataTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        femaleKyaaaaDataTableView.dataSource = self
        femaleKyaaaaDataTableView.delegate = self
        
        femaleKyaaaaDataTableView.rowHeight = 400
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        femaleKyaaaaDataTableView.register(nib, forCellReuseIdentifier: "Cell")
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getkyaaaaPost()
        getUserData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell
             //cellで用意したdelegateメソッドをこのViewControllerで書く
             cell.delegate = self
             cell.tag = indexPath.row
             if let userImageURL = posts[indexPath.row].userPhotoURL {
                 let url = URL(string: userImageURL)
                 if url != nil {
                     do {
                         let data = try Data(contentsOf: url!)
                         cell.userImageView.image = UIImage(data: data)
                     } catch let err {
                         print("Error : \(err.localizedDescription)")
                         cell.userImageView.image = UIImage(named: "male-placeHolder.jpg")
                     }
                 }
             } else {
                 cell.userImageView.image = UIImage(named: "male-placeHolder.jpg")
             }
        
             if let userName = posts[indexPath.row].userName {
               cell.fromNameLabel.text = userName
             } else {
               cell.fromNameLabel.text = "NoData"
             }
             
             if let age = posts[indexPath.row].age {
                 cell.ageLabel.text = age
             } else {
                 cell.ageLabel.text = ""
             }
             if let initial = posts[indexPath.row].initial {
                 cell.initialLabel.text = initial
             } else {
                 cell.initialLabel.text = ""
             }
             if let text = posts[indexPath.row].text {
                 cell.textView.text = text
             } else {
                 cell.textView.text = ""
             }
             if let kyaaaaCount = posts[indexPath.row].kyaaaaUsers?.count {
                 cell.kaaaaaCountLabel.text = String(kyaaaaCount)
             } else {
                 cell.kaaaaaCountLabel.text = "0"
             }
             if let sorenaCount = posts[indexPath.row].sorenaUsers?.count {
                 cell.sorenaCountLabel.text = String(sorenaCount)
             } else {
                 cell.sorenaCountLabel.text = "0"
             }
             if let naruhodoCount = posts[indexPath.row].naruhodoUsers?.count {
                 cell.naruhodoCountLabel.text = String(naruhodoCount)
             } else {
                 cell.naruhodoCountLabel.text = "0"
             }
            
             
             return cell
    }
    func didTapSorenaButton(tableViewCell: UITableViewCell, button: UIButton) {
        selectedPost = posts[tableViewCell.tag]
        self.selectedPost!.sorena(collection: "Femailposts") { (error) in
            if let error = error {
                HUD.show(.error)
                print("error === " + error.localizedDescription)
            } else {
                self.getkyaaaaPost()
            }
        }
    }
    
    func didTapNaruhodoButton(tableViewCell: UITableViewCell, button: UIButton) {
        selectedPost = posts[tableViewCell.tag]
        self.selectedPost!.naruhodo(collection: "Femailposts") { (error) in
            if let error = error {
                print("error === " + error.localizedDescription)
            } else {
                self.getkyaaaaPost()
            }
        }
    }
        
    func didTapKyaaaaButton(tableViewCell: UITableViewCell, button: UIButton) {
        selectedPost = posts[tableViewCell.tag]
         self.selectedPost!.kyaaaa(collection: "Femailposts") { (error) in
             if let error = error {
                 print("error === " + error.localizedDescription)
             } else {
                 self.getkyaaaaPost()
             }
         }
    }
    
    func didTapShareButton(tableViewCell: UITableViewCell, button: UIButton) {
       let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
       
        let alert = SCLAlertView(appearance: appearance)
       alert.addButton("共有") {
                        //ActivityViewController
         self.selectedPost = self.posts[tableViewCell.tag]
                                 
         var dear = self.selectedPost?.age
         var text = self.selectedPost?.text
         var items = ["Dear\(dear)",text] as [Any]
         print(items)
                                 // UIActivityViewControllerをインスタンス化
         let activityVc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                                 // UIAcitivityViewControllerを表示
         self.present(activityVc, animated: true, completion: nil)
               
       }
       
       if self.posts[tableViewCell.tag].userId == currentUser?.uid {
           alert.addButton("削除する") {
               if let deletePostId = self.posts[tableViewCell.tag].uid {
                   self.deletePost(selfPostId: deletePostId) { (error) in
                       if error != nil {
                           print(error)
                           HUD.flash(.error, delay: 1.0)
                       } else {
                           HUD.flash(.success, delay: 1.0)
                           self.getkyaaaaPost()
                       }
                   }
               } else {
                   return
               }
           
           }
       } else {
           alert.addButton("ブロック") {
                           
             if let blockUserId = self.posts[tableViewCell.tag].userId {
               self.blockUser(selfUserId: self.currentUser!.uid, blockUserId: blockUserId) { (error) in
                   if error != nil {
                       print(error)
                       HUD.flash(.error, delay: 1.0)
                   } else {
                       HUD.flash(.success, delay: 1.0)
                       self.getkyaaaaPost()
                   }
                                   
                               
               }
             } else {
                 return
             }
             
           }
       }
       
       
       alert.addButton("キャンセル") {
           print("cancel")
       }
       alert.showInfo("", subTitle: "テキストを共有します")
    }
    
    func blockUser(selfUserId: String, blockUserId: String, completion: @escaping(Error?) -> ()) {
        let db = Firestore.firestore()
        db.document("users/\(selfUserId)").updateData(["blockId": FieldValue.arrayUnion([blockUserId])]) { (error) in
            completion(error)
        }
    }
        
    
    func getUserData() {
        // Firestoreのデータベースを取得
        let db = Firestore.firestore()
        if currentUser != nil {
            let docRef = db.collection("users").document(currentUserId!)
            docRef.getDocument { (document, error) in
                self.userBlockIds = []
                if let document = document, document.exists {
                    let dataDescription = document.data() as! [String:Any]
                    
                    if dataDescription["blockId"] != nil {
                        for i in dataDescription["blockId"] as! [String] {
                            self.userBlockIds.append(i)
                        }
                       
                    } else {
                        self.userBlockIds = []
                    }
                    
                   
                }
            }
        }
        
    }
    
    
    
    func getkyaaaaPost(isAdditional: Bool = false) {
        let db = Firestore.firestore()
        if currentUserId != nil {
            Post.getUserkyaaaPost(blockIds: userBlockIds,collection: "Femailposts", userId: self.currentUserId!, isAdditional: isAdditional, lastSnapshot: self.lastSnapshot) { (posts, lastSnapshot, error) in
                // 読み込み完了
                self.isLoading = false
                self.lastSnapshot = lastSnapshot
                
                if let error = error {
                    print(error)
                    // エラー処理
                   // self.showError(error: error)
                    HUD.show(.error)
                } else {
                   // 読み込みが成功した場合
                   if let posts = posts {
                       // 追加読み込みなら配列に追加、そうでないなら配列に再代入
                       if isAdditional == true {
                           self.posts = self.posts + posts
                       } else {
                           self.posts = posts
                           
                       }
                       print("成功")
                       print(posts)
                       self.femaleKyaaaaDataTableView.reloadData()
                   }
                }
            }
            
        } else {
            //ログイン画面に移動
            
        }
        
    }
    
    func deletePost(selfPostId: String, completion: @escaping(Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection("Femailposts").document(selfPostId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                HUD.flash(.error, delay: 0.5)
            } else {
                print("Document successfully removed!")
                self.getkyaaaaPost()
                HUD.flash(.success, delay: 0.5)
            }
        }
    }
    
     
}
