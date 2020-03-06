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

class FemailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,TimeLineTableViewCellDelegate,UIViewControllerTransitioningDelegate,ASCircularButtonDelegate {
    
    @IBOutlet var shareButton: ASCircularMenuButton!
    @IBOutlet var colourPickerButton: ASCircularMenuButton!
    let colourArray: [UIColor] = [.red , .blue , .green , .yellow , .purple , .gray , .black, .black]
    let shareName: [String] = ["小","中","高","19~","23~","30~","40~","50~"]
    var ageNumDictionary: [Int: String] = [0:"小学生",1:"中学生", 2:"高校生", 3:"19~22歳", 4:"23~29歳", 5:"30~39歳", 6:"40~49歳", 7:"50歳~"]
    
    
    let transition = BubbleTransition()
    
    func didClickOnCircularMenuButton(_ menuButton: ASCircularMenuButton, indexForButton: Int, button: UIButton) {
        
        if menuButton == colourPickerButton{
        }
        
        if menuButton == shareButton {
           posts = [Post]()
            if let age = ageNumDictionary[indexForButton] {
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


        postButton.isEnabled = false
      
        // Do any additional setup after loading the view.
        
        // これを実行しないと context.biometryType が有効にならないので一度実行
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        state = .loggedout
        
        FemaleTableView.dataSource = self
        FemaleTableView.dataSource = self
        
        FemaleTableView.rowHeight = 400
        
        buttonShadow()
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        FemaleTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        
        configureDynamicCircularMenuButton(button: shareButton, numberOfMenuItems: 8)
        shareButton.menuButtonSize = .large
        
        configureDraggebleCircularMenuButton(button: colourPickerButton, numberOfMenuItems: 8, menuRedius: 70, postion: .center)
        colourPickerButton.menuButtonSize = .medium
        colourPickerButton.sholudMenuButtonAnimate = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTimeline()
        getUserData()
    }
    
    func loadData(isAdditional: Bool = false, filterAge: String) {
        isLoading = true
        Post.getAgeData(age: filterAge, collection: "Femailposts", isAdditional: isAdditional, lastSnapshot: lastSnapshot) { (posts, lastSnapshot, error) in
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell
        cell.delegate = self
        cell.tag = indexPath.row
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
