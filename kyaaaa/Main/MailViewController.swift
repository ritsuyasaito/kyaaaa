//
//  MailViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/02/28.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import LocalAuthentication
import FirebaseAuth
import Firebase
import PKHUD
import ViewAnimator
import BubbleTransition
import ASExtendedCircularMenu



//女子から男子へ、女子の投稿
class MailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TimeLineTableViewCellDelegate ,UIViewControllerTransitioningDelegate,ASCircularButtonDelegate{
    
    
    @IBOutlet var shareButton: ASCircularMenuButton!
    @IBOutlet var colourPickerButton: ASCircularMenuButton!
    let colourArray: [UIColor] = [.red , .blue , .green , .yellow , .purple , .gray ,.black , .brown]
    let shareName: [String] = ["小","中","高","大","30代","40代","50代","60代"]
  
    
    // UILongPressGestureRecognizer宣言
    var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "cellLongPressed:")

    
    
    func didClickOnCircularMenuButton(_ menuButton: ASCircularMenuButton, indexForButton: Int, button: UIButton) {
   
        if menuButton == colourPickerButton{
        }
        if menuButton == shareButton{
            
          
            if indexForButton == 0{
                print("小学生")
            }else if indexForButton == 1{
                print("中学生")
            }else if indexForButton == 2{
                print("高校生")
            }else if indexForButton == 3{
                print("大学生")
            }else if indexForButton == 4{
                
            }else if indexForButton == 5{
                
            }else if indexForButton == 6{
                
            }else if indexForButton == 7{
                
            }else if indexForButton == 8{
                
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
    
    
    
    let transition = BubbleTransition()
    
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
        self.selectedPost!.sorena(collection: "Mailposts") { (error) in
            if let error = error {
                HUD.show(.error)
                print("error === " + error.localizedDescription)
            } else {
                self.loadTimeline()
            }
        }
        
    }
    
    func didTapNaruhodoButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        print(tableViewCell.tag)
        selectedPost = posts[tableViewCell.tag]
        self.selectedPost!.naruhodo(collection: "Mailposts") { (error) in
            if let error = error {
                print("error === " + error.localizedDescription)
            } else {
                self.loadTimeline()
            }
        }
    }
    
    func didTapKyaaaaButton(tableViewCell: UITableViewCell, button: UIButton) {
        selectedPost = posts[tableViewCell.tag]
        
        print(selectedPost)
        self.selectedPost!.kyaaaa(collection: "Mailposts") { (error) in
            if let error = error {
                print("error === " + error.localizedDescription)
            } else {
                self.loadTimeline()
            }
        }
        
    }
    
    func didTapShareButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        let alertController = UIAlertController(title: "テキストを共有します", message: "", preferredStyle: .alert)
        let otherShareAction = UIAlertAction(title: "共有", style: UIAlertAction.Style.default) { (action) in
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
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            
        }
        
        alertController.addAction(otherShareAction)
        alertController.addAction(cancelAction)
        
        present(alertController,animated: true,completion: nil)
    }
    
    
    let currentUser = Auth.auth().currentUser
    var userGender: String = ""
    @IBOutlet var postButton: UIButton!
    
    
    @IBOutlet var maleTableView: UITableView!
    
    var posts = [Post]()
    var selectedPost: Post?
    // 読み込み中かどうかを判別する変数(読み込み結果が0件の場合DZNEmptyDataSetで空の表示をさせるため)
    var isLoading: Bool = false
    
    // 下に引っ張って追加読み込みしたい場合に使う、読み込んだ投稿の最後の投稿を保存する変数
    var lastSnapshot: DocumentSnapshot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // これを実行しないと context.biometryType が有効にならないので一度実行
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        state = .loggedout
        

        postButton.isEnabled = false


        // Do any additional setup after loading the view.
        getUserData()
        
        maleTableView.delegate = self
        maleTableView.dataSource = self
        
        maleTableView.rowHeight = 400
        
        buttonShadow()
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        maleTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        configureDynamicCircularMenuButton(button: shareButton, numberOfMenuItems: 8)
        shareButton.menuButtonSize = .large
        
        configureDraggebleCircularMenuButton(button: colourPickerButton, numberOfMenuItems: 8, menuRedius: 70, postion: .center)
        colourPickerButton.menuButtonSize = .medium
        colourPickerButton.sholudMenuButtonAnimate = false
        
        // `UIGestureRecognizerDelegate`を設定するのをお忘れなく
        longPressRecognizer.delegate = self as! UIGestureRecognizerDelegate

        // tableViewにrecognizerを設定
        maleTableView.addGestureRecognizer(longPressRecognizer)
        
        
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //         let fromAnimation = AnimationType.from(direction: .right, offset: 50.0)
    //               let zoomAnimation = AnimationType.zoom(scale: 0.3)
    //               let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
    //               UIView.animate(views: maleTableView.visibleCells,
    //                              animations: [fromAnimation, zoomAnimation,rotateAnimation],
    //                              duration: 1.2)
    //        maleTableView.reloadData()
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
        loadTimeline()
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
                        if self.userGender == "男" {
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
        Post.getAll(collection: "Mailposts", isAdditional: isAdditional, lastSnapshot: lastSnapshot) { (posts, lastSnapshot, error) in
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
                    self.maleTableView.reloadData()
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
    
    @IBAction func toPostPage() {
        if userGender == "男" {
            
        }
        performSegue(withIdentifier: "toPostPage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserPage" {
            
        } else if segue.identifier == "toPostPage" {
            let postVC = segue.destination as! PostViewController
            postVC.transitioningDelegate = self
            postVC.modalPresentationStyle = .custom
            postVC.fromGender = "男性から"
        }
    }
    
    
    
    
    
}
