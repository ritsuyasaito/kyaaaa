//
//  FemailViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/03/01.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import Firebase
import PKHUD
import DZNEmptyDataSet
import LocalAuthentication

class FemailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,TimeLineTableViewCellDelegate {
    
    func didTapSorenaButton(tableViewCell: UITableViewCell, button: UIButton) {
        selectedPost = posts[tableViewCell.tag]
        self.selectedPost!.sorena(collection: "Femailposts") { (error) in
            if let error = error {
                print("error === " + error.localizedDescription)
            } else {
                self.loadTimeline()
            }
        }
    }
    
    func didTapNaruhodoButton(tableViewCell: UITableViewCell, button: UIButton) {
        selectedPost = posts[tableViewCell.tag]
        self.selectedPost!.naruhodo(collection: "Femailposts") { (error) in
            if let error = error {
                print("error === " + error.localizedDescription)
            } else {
                self.loadTimeline()
            }
        }
    }
    
    func didTapKyaaaaButton(tableViewCell: UITableViewCell, button: UIButton) {
        selectedPost = posts[tableViewCell.tag]
        
         self.selectedPost!.kyaaaa(collection: "Femailposts") { (error) in
             if let error = error {
                 print("error === " + error.localizedDescription)
             } else {
                 self.loadTimeline()
             }
         }
    }
    
    func didTapShareButton(tableViewCell: UITableViewCell, button: UIButton) {
        selectedPost = posts[tableViewCell.tag]
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let otherShareAction = UIAlertAction(title: "共有", style: UIAlertAction.Style.default) { (action) in
            //ActivityViewController
            
           // let text = self.selectedPost?.user.displayName
           // let text2 = self.selectedPost?.text
            let dear = self.selectedPost?.age
            let text = self.selectedPost?.text
            let items = ["Dear\(dear)",text] as [Any]
            // UIActivityViewControllerをインスタンス化
            let activityVc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            // UIAcitivityViewControllerを表示
            self.present(activityVc, animated: true, completion: nil)
            
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            
        }
        
        alertController.addAction(otherShareAction)
        alertController.addAction(cancelAction)
        
        present(alertController,animated: true,completion: nil)
        
        
    }
    
    
    
    var posts = [Post]()
    var selectedPost: Post?
    let currentUser = Auth.auth().currentUser
    var userGender: String = ""
    
    @IBOutlet var postButton: UIButton!
    
    @IBOutlet var FemaleTableView: UITableView!
    
    // 読み込み中かどうかを判別する変数(読み込み結果が0件の場合DZNEmptyDataSetで空の表示をさせるため)
    var isLoading: Bool = false
    
    // 下に引っ張って追加読み込みしたい場合に使う、読み込んだ投稿の最後の投稿を保存する変数
    var lastSnapshot: DocumentSnapshot?

    override func viewDidLoad() {
        super.viewDidLoad()

      
        // Do any additional setup after loading the view.
        
        // これを実行しないと context.biometryType が有効にならないので一度実行
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        state = .loggedout
        
        FemaleTableView.dataSource = self
        FemaleTableView.dataSource = self
        
        FemaleTableView.rowHeight = 400
        
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        FemaleTableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTimeline()
        getUserData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell
        cell.delegate = self
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
        if let sorenaCount = posts[indexPath.row].kyaaaaUsers?.count {
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
    
    @IBAction func toPostPage() {
        performSegue(withIdentifier: "toPostPage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserPage" {
            
        } else if segue.identifier == "toPostPage" {
            let postVC = segue.destination as! PostViewController
            postVC.fromGender = "女性から"
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
                    
                    if dataDescription["gender"] != nil {
                        self.userGender = dataDescription["gender"] as! String
                        if self.userGender == "女" {
                            self.postButton.isEnabled = true
                        } else {
                            self.postButton.isEnabled = false
                        }
                        
                    }
                }
            }
        }

    }

    

    func loadTimeline(isAdditional: Bool = false) {
        isLoading = true
        Post.getAll(collection: "Femailposts", isAdditional: isAdditional, lastSnapshot: lastSnapshot) { (posts, lastSnapshot, error) in
            // 読み込み完了
            self.isLoading = false
            self.lastSnapshot = lastSnapshot
            //self.timelineTableView.headRefreshControl.endRefreshing()
           // self.timelineTableView.footRefreshControl.endRefreshing()
            
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
                    self.FemaleTableView.reloadData()
                    
                }
            }
        }
        
    }
    
    //   ----------------パスワード要求ー---------------
    
    enum AuthenticationState {
        case loggedin, loggedout
    }
    var state: AuthenticationState = .loggedout {
        didSet {
      
        }
    }
    var context: LAContext = LAContext()
    
    @IBAction func didTabLoginButton(_ sender: Any) {
        
        guard state == .loggedout else {
            self.performSegue(withIdentifier: "toUserPage", sender: nil)
            state = .loggedout
            return
        }
        
        context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            
            let reason = "本人認証を行います"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        self.performSegue(withIdentifier: "toUserPage", sender: nil)
                        self.state = .loggedin
                    }
                } else if let laError = error as? LAError {
                    switch laError.code {
                    case .authenticationFailed:
                        break
                    case .userCancel:
                        break
                    case .userFallback:
                        break
                    case .systemCancel:
                        break
                    case .passcodeNotSet:
                        break
                    case .touchIDNotAvailable:
                        break
                    case .touchIDNotEnrolled:
                        break
                    case .touchIDLockout:
                        break
                    case .appCancel:
                        break
                    case .invalidContext:
                        break
                    case .notInteractive:
                        break
                    @unknown default:
                        break
                    }
                }
            }
        } else {
            // 生体認証ができない場合の認証画面表示など
        }
    }

}
