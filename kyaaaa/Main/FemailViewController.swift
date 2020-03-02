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

class FemailViewController: UIViewController {
    
    
    var posts = [Post]()
    
    // 読み込み中かどうかを判別する変数(読み込み結果が0件の場合DZNEmptyDataSetで空の表示をさせるため)
    var isLoading: Bool = false
    
    // 下に引っ張って追加読み込みしたい場合に使う、読み込んだ投稿の最後の投稿を保存する変数
    var lastSnapshot: DocumentSnapshot?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTimeline()
        // Do any additional setup after loading the view.
    }
    

    func loadTimeline(isAdditional: Bool = false) {
        isLoading = true
        Post.getAll(isAdditional: isAdditional, lastSnapshot: lastSnapshot) { (posts, lastSnapshot, error) in
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
                    
                }
            }
        }
        
        
    }

}
