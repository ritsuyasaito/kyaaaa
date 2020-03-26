//
//  privacyViewController.swift
//  kyaaaa
//
//  Created by 藤田えりか on 2020/03/26.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit

class privacyViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
       
       
       @IBOutlet var agreeButton: UIButton!
       
       
       
       override func viewDidLoad() {
           super.viewDidLoad()
           //角丸
           agreeButton.layer.cornerRadius = agreeButton.bounds.width / 20.0
           
           //ボタンに影をつける
           agreeButton.layer.shadowColor = UIColor.black.cgColor
           agreeButton.layer.shadowOffset = CGSize(width: 3, height: 3)
           agreeButton.layer.shadowOpacity = 0.2
           agreeButton.layer.masksToBounds = false
       }
       
       @IBAction func agree(){
           //        navigationController?.popViewController(animated: true)
           //        今回はmodalで遷移しているからdismissで
           self.dismiss(animated: true, completion: nil)
       }
       

}
