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
import ViewAnimator
import BubbleTransition
import ASExtendedCircularMenu
import SCLAlertView
import TransitionButton

//public protocol Animation {
//    var initialTransform: CGAffineTransform { get }
//}

class FemailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,TimeLineTableViewCellDelegate,UIViewControllerTransitioningDelegate,ASCircularButtonDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet var shareButton: ASCircularMenuButton!
    @IBOutlet var colourPickerButton: ASCircularMenuButton!
    
    @IBOutlet var longPressGesRec: UILongPressGestureRecognizer!
    
    let colourArray: [UIColor] = [.red , .orange , .systemGreen , .blue , .gray]
    let shareName: [String] = ["小","中","高","大","社"]
    var ageNumDictionary: [Int: String] = [0:"小学生",1:"中学生", 2:"高校生", 3:"大学生", 4:"社会人"]
    var strFilter: String = ""
    
    
    
    let transition = BubbleTransition()
    
    // UILongPressGestureRecognizerのdelegate：ロングタップを検出する
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        // ロングタップ開始
        if sender.state == .began {
        }
            // ロングタップ終了（手を離した）
        else if sender.state == .ended {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("はい") {
                
                
            }
            alert.addButton("いいえ") {
                print("cancel")
            }
            //                    alert.showInfo("", subTitle: "報告しますか?")
            alert.showWarning("", subTitle: "報告しますか?")
            /*
             let alert = UIAlertController(title: nil, message: "報告しますか", preferredStyle: .alert)
             var action = UIAlertAction(title: "いいえ", style: .default) { (action) in
             alert.dismiss(animated: true, completion: nil)
             self.navigationController?.popViewController(animated: true)//元の画面に戻る
             }
             let action2 = UIAlertAction(title: "はい", style: .default, handler: { (action) in
             
             
             alert.dismiss(animated: true, completion: nil)
             })
             alert.addAction(action)
             alert.addAction(action2)
             self.present(alert, animated: true,completion: nil)
             */
        }
    }
    
    func didClickOnCircularMenuButton(_ menuButton: ASCircularMenuButton, indexForButton: Int, button: UIButton) {
        
        if menuButton == colourPickerButton{
        }
        
        if menuButton == shareButton {
            posts = [Post]()
            if let age = ageNumDictionary[indexForButton] {
                strFilter = age
                loadData(filterAge: age)
            } else {
                print("Data取得失敗")
            }
            
        }
        
    }
    
    func buttonForIndexAt(_ menuButton: ASCircularMenuButton, indexForButton: Int) -> UIButton {
        
        let button: UIButton = UIButton()
        if menuButton == shareButton{
            //            button.setBackgroundImage(UIImage.init(named: "shareicon.\(indexForButton + 1)"), for: .normal)
            button.backgroundColor = colourArray[indexForButton]
            button.setTitle(shareName[indexForButton], for: .normal)
            
        }
        if menuButton == colourPickerButton{
            button.backgroundColor = colourArray[indexForButton]
        }
        return button
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = postButton.center
        //        transition.bubbleColor = postButton.backgroundColor!
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = postButton.center
        //        transition.bubbleColor = postButton.backgroundColor!
        return transition
    }
    func buttonShadow(){
        postButton.layer.shadowColor = UIColor.black.cgColor
        postButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        postButton.layer.shadowOpacity = 0.2
        postButton.layer.masksToBounds = false
        
    }
    
    
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
                            self.loadTimeline()
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
                            self.loadTimeline()
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
    
    var userBlockIds = [String]()
    
    
    
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
        
        
        postButton.isEnabled = false
        
        FemaleTableView.backgroundColor = UIColor.clear
        // これを実行しないと context.biometryType が有効にならないので一度実行
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        state = .loggedout
        
        FemaleTableView.dataSource = self
        FemaleTableView.dataSource = self
        
        //        FemaleTableView.rowHeight = 400
        FemaleTableView.estimatedRowHeight = 10000
        FemaleTableView.rowHeight = UITableView.automaticDimension
        buttonShadow()
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        FemaleTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        
        configureDynamicCircularMenuButton(button: shareButton, numberOfMenuItems: 8)
        shareButton.menuButtonSize = .large
        
        configureDraggebleCircularMenuButton(button: colourPickerButton, numberOfMenuItems: 8, menuRedius: 70, postion: .center)
        colourPickerButton.menuButtonSize = .medium
        colourPickerButton.sholudMenuButtonAnimate = false
        
        longPressGesRec.delegate = self
        FemaleTableView.addGestureRecognizer(longPressGesRec)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
        let zoomAnimation = AnimationType.zoom(scale: 0.7)
        //           let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
        UIView.animate(views: FemaleTableView.visibleCells,
                       animations: [fromAnimation, zoomAnimation],
                       duration: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTimeline()
        getUserData()
    }
    
    func loadData(isAdditional: Bool = false, filterAge: String) {
        isLoading = true
        Post.getAgeData(blockIds: userBlockIds,age: filterAge, collection: "Femailposts", isAdditional: isAdditional, lastSnapshot: lastSnapshot) { (posts, lastSnapshot, error) in
            // 読み込み完了
            self.isLoading = false
            self.lastSnapshot = lastSnapshot
            //self.timelineTableView.headRefreshControl.endRefreshing()
            // self.timelineTableView.footRefreshControl.endRefreshing()
            
            if let error = error {
                print(error)
                // エラー処理
                // self.showError(error: error)
//                HUD.show(.error)
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
                    self.FemaleTableView.reloadData()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
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
            cell.fromNameLabel.text = ""
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
        if posts[indexPath.row].isKyaaaa == true {
            cell.kyaaaaButton.setImage(UIImage(named: "heart-fill"), for: .normal)
        } else {
            cell.kyaaaaButton.setImage(UIImage(named: "like"), for: .normal)
        }
        if posts[indexPath.row].isNaruhodo == true {
            cell.naruhodoButton.setImage(UIImage(named: "heart-fill"), for: .normal)
        } else {
            cell.naruhodoButton.setImage(UIImage(named: "like"), for: .normal)
        }
        if posts[indexPath.row].isSorena == true {
            cell.sorenaButton.setImage(UIImage(named: "heart-fill"), for: .normal)
        } else {
            cell.sorenaButton.setImage(UIImage(named: "like"), for: .normal)
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
            postVC.transitioningDelegate = self
            postVC.modalPresentationStyle = .custom
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
                    
                    if dataDescription["blockId"] != nil {
                        for i in dataDescription["blockId"] as! [String] {
                            self.userBlockIds.append(i)
                        }
                        
                    } else {
                        self.userBlockIds = []
                    }
                    
                    
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
        if strFilter == "" {
            isLoading = true
            Post.getAll(blockIds: userBlockIds, collection: "Femailposts", isAdditional: isAdditional, lastSnapshot: lastSnapshot) { (posts, lastSnapshot, error) in
                // 読み込み完了
                self.isLoading = false
                self.lastSnapshot = lastSnapshot
                //self.timelineTableView.headRefreshControl.endRefreshing()
                // self.timelineTableView.footRefreshControl.endRefreshing()
                
                if let error = error {
                    print(error)
                    // エラー処理
                    // self.showError(error: error)
//                    HUD.show(.error)
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
                        self.FemaleTableView.reloadData()
                        
                    }
                }
            }
        } else {
            loadData(filterAge: strFilter)
        }
        
    }
    
    func blockUser(selfUserId: String, blockUserId: String, completion: @escaping(Error?) -> ()) {
        let db = Firestore.firestore()
        db.document("users/\(selfUserId)").updateData(["blockId": FieldValue.arrayUnion([blockUserId])]) { (error) in
            completion(error)
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
                self.loadTimeline()
                HUD.flash(.success, delay: 0.5)
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
