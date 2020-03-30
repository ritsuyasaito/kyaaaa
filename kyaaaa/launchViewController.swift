//
//  launchViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/03/30.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit

class launchViewController: UIViewController {
    
    var logoImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black

        //imageView作成
self.logoImageView = UIImageView(frame: CGRect(x: self.view.bounds.width/2, y: self.view.bounds.height/2, width: 350.0, height: 350.0))        //画面centerに
        self.logoImageView.center = self.view.center
        //logo設定
        self.logoImageView.image = UIImage(named: "kyaaaa_black.jpg")
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
        UIView.animate(withDuration: 0.3,
            delay: 1.0,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: { () in
                self.logoImageView.transform = CGAffineTransform(scaleX: 7.0, y: 7.0)
                self.logoImageView.alpha = 0
            }, completion: { (Bool) in
                self.logoImageView.removeFromSuperview()
                self.performSegue(withIdentifier: "toStart", sender: nil)

        })
    }
    

    
}
