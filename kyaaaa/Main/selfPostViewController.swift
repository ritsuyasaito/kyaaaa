//
//  selfPostViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/03/04.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import PKHUD
import SCLAlertView

class selfPostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TimeLineTableViewCellDelegate {
    
    let currentUserId = Auth.auth().currentUser?.uid
    var gender = ""
    var collect = ""
    
    // 読み込み中かどうかを判別する変数(読み込み結果が0件の場合DZNEmptyDataSetで空の表示をさせるため)
    var isLoading: Bool = false
    
    // 下に引っ張って追加読み込みしたい場合に使う、読み込んだ投稿の最後の投稿を保存する変数
    var lastSnapshot: DocumentSnapshot?
    
    var posts = [Post]()
    var selectedPost: Post?

    @IBOutlet var userPosttableView: UITableView!
    
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPosttableView.delegate = self
        userPosttableView.dataSource = self
        
        userPosttableView.rowHeight = 400
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        userPosttableView.register(nib, forCellReuseIdentifier: "Cell")

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserPost()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell
        cell.baseView.alpha = 0.8
        cell.textView.alpha = 0.8
        
        switch posts[indexPath.row].age {
        case "小学生":
            cell.baseView.backgroundColor = UIColor.red
            cell.textView.backgroundColor = UIColor.red
        case "中学生":
            cell.baseView.backgroundColor = UIColor.orange
            cell.textView.backgroundColor = UIColor.orange
        case "高校生":
            cell.baseView.backgroundColor = UIColor.systemGreen
            cell.textView.backgroundColor = UIColor.systemGreen
        case "大学生":
            cell.baseView.backgroundColor = UIColor.blue
            cell.textView.backgroundColor = UIColor.blue
        case "社会人":
            cell.baseView.backgroundColor = UIColor.gray
            cell.textView.backgroundColor = UIColor.gray
            
        default:
            cell.baseView.backgroundColor = UIColor(red: 146/255, green: 84/255, blue: 255/255, alpha: 0.8)
            cell.textView.backgroundColor = UIColor(red: 146/255, green: 84/255, blue: 255/255, alpha: 0.8)
        }
        
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
        self.selectedPost!.sorena(collection: "Mailposts") { (error) in
            if let error = error {
//                HUD.show(.error)
                HUD.flash(.error, delay: 0.5)
                print("error === " + error.localizedDescription)
            } else {
                self.getUserPost()
            }
        }
    }
    
    func didTapNaruhodoButton(tableViewCell: UITableViewCell, button: UIButton) {
        selectedPost = posts[tableViewCell.tag]
        self.selectedPost!.naruhodo(collection: "Mailposts") { (error) in
            if let error = error {
                print("error === " + error.localizedDescription)
            } else {
                self.getUserPost()
            }
        }
    }
    
    func didTapKyaaaaButton(tableViewCell: UITableViewCell, button: UIButton) {
        selectedPost = posts[tableViewCell.tag]
         self.selectedPost!.kyaaaa(collection: "Mailposts") { (error) in
             if let error = error {
                 print("error === " + error.localizedDescription)
             } else {
                 self.getUserPost()
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
                     alert.addButton("削除する") {
                        if let selectedId = self.posts[tableViewCell.tag].uid {
                            let db = Firestore.firestore()
                            db.collection(self.collect).document(selectedId).delete() { err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                    HUD.flash(.error, delay: 0.5)
//                                    HUD.flash(.progress, delay: 3)

                                } else {
                                    print("Document successfully removed!")
                                    self.getUserPost()
                                    HUD.flash(.success, delay: 0.5)
                                }
                            }
                        }

                        
                      }
                     
        
        
                     alert.addButton("キャンセル") {
                         print("cancel")
                     }
                     alert.showInfo("", subTitle: "テキストを共有します")
        
        
        
    }
    
    
    
    
    func getUserPost(isAdditional: Bool = false) {
        let db = Firestore.firestore()
        if currentUserId != nil {
            let docRef = db.collection("users").document(currentUserId!)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() as! [String:Any]
                    
                    if dataDescription["gender"] != nil {
                        self.gender = dataDescription["gender"] as! String
                        if self.gender == "男" {
                            self.collect = "Mailposts"
                            Post.getUserPost(collection: "Mailposts", userId: self.currentUserId!, isAdditional: isAdditional) { (posts, lastSnapshot, error) in
                                // 読み込み完了
                                self.isLoading = false
                                self.lastSnapshot = lastSnapshot
                                
                                if let error = error {
                                    print(error)
                                    // エラー処理
                                   // self.showError(error: error)
//                                    HUD.show(.error)
//                                    HUD.show(.error, delay: 1.0)
                                    HUD.flash(.error, delay: 1.0)
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
                                       self.userPosttableView.reloadData()
                                   }
                                  
                                  
                                }
                            }
                            Post.getUserPost(collection: "Mailposts", userId: self.currentUserId!) { (posts, lastSnapshot, error) in
                                
                            }
                        } else {
                            self.collect = "Femailposts"
                            Post.getUserPost(collection: "Femailposts", userId: self.currentUserId!, isAdditional: isAdditional) { (posts, lastSnapshot, error) in
                                // 読み込み完了
                                self.isLoading = false
                                self.lastSnapshot = lastSnapshot
                                
                                if let error = error {
                                    print(error)
                                    // エラー処理
                                   // self.showError(error: error)
                                    
                                    HUD.flash(.error, delay: 0.5)
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
                                       self.userPosttableView.reloadData()
                                   }
                                  
                                  
                                }
                            }
                        }
                        
                    }
                }
            }
        }
    }
    

}


