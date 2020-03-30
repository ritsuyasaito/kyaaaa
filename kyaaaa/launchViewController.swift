//
//  launchViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/03/30.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit

class launchViewController: UIViewController {
    
    var logoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        //imageView作成
        //self.logoImageView = UIImageView(frame: CGRectMake(0, 0, 204, 77))
        //画面centerに
        self.logoImageView.center = self.view.center
        //logo設定
        self.logoImageView.image = UIImage(named: "logo")
        //viewに追加
        self.view.addSubview(self.logoImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //少し縮小するアニメーション
        UIView.animate(withDuration: 0.3,
            delay: 1.0,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: { () in
                self.logoImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { (Bool) in

        })

        //拡大させて、消えるアニメーション
        UIView.animate(withDuration: 0.2,
            delay: 1.3,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: { () in
                self.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.logoImageView.alpha = 0
            }, completion: { (Bool) in
                self.logoImageView.removeFromSuperview()
        })
    }
    

    
}
