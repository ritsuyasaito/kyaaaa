//
//  NavigationViewController.swift
//  kyaaaa
//
//  Created by 藤田えりか on 2020/03/11.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
//let myColor = UIColor(red: 154/255, green: 215/255,  blue: 50/255, alpha: 1.0)

        //　ナビゲーションバーの背景色
        navigationBar.barTintColor = UIColor.black
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        navigationBar.tintColor = .white
        // ナビゲーションバーのテキストを変更する
        navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.white
        ]


    }
    


}
