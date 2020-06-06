//
//  FirstViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/03/02.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import ViewAnimator

class FirstViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var ageTableView: UITableView!
    var ageArray = ["kyaaaa!","小学生","中学生","高校生","大学生","30代","40代","50代","60代以上"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ageTableView.delegate = self
        ageTableView.dataSource = self

        ageTableView.rowHeight = 100
        ageTableView.tableFooterView = UIView()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
         let fromAnimation = AnimationType.from(direction: .right, offset: 50.0)
               let zoomAnimation = AnimationType.zoom(scale: 0.3)
               let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
               UIView.animate(views: ageTableView.visibleCells,
                              animations: [fromAnimation, zoomAnimation,rotateAnimation],
                              duration: 1.2)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ageArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ageCell")!
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        cell.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        //      cell.layer.shadowOffset = CGSizeMake(0, 0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.23
        cell.layer.shadowRadius = 4
        
        switch indexPath.row {
               case 0:
                   cell.backgroundColor = UIColor(red: 255/255, green: 193/255, blue: 230/255, alpha: 1.0)
               case 1:
                   cell.backgroundColor = UIColor(red: 255/255, green: 143/255, blue: 118/255, alpha: 1.0)
               case 2:
                   cell.backgroundColor = UIColor(red: 255/255, green: 174/255, blue: 103/255, alpha: 1.0)
               case 3:
                   cell.backgroundColor = UIColor(red: 193/255, green: 255/255, blue: 156/255, alpha: 1.0)
               case 4:
                   cell.backgroundColor = UIColor(red: 158/255, green: 186/255, blue: 255/255, alpha: 1.0)
               case 5:
                   cell.backgroundColor = UIColor(red: 255/255, green: 193/255, blue: 230/255, alpha: 1.0)
               case 6:
                   cell.backgroundColor = UIColor(red: 255/255, green: 143/255, blue: 118/255, alpha: 1.0)
               case 7:
                   cell.backgroundColor = UIColor(red: 255/255, green: 174/255, blue: 103/255, alpha: 1.0)
               case 8:
                   cell.backgroundColor = UIColor(red: 193/255, green: 255/255, blue: 156/255, alpha: 1.0)
               case 9:
                   cell.backgroundColor = UIColor(red: 158/255, green: 186/255, blue: 255/255, alpha: 1.0)
              
        default:
             cell.backgroundColor = UIColor(red: 158/255, green: 186/255, blue: 255/255, alpha: 1.0)
        }
               cell.textLabel?.text = ageArray[indexPath.row]
        
               cell.textLabel?.font = UIFont.systemFont(ofSize:  40)
               cell.textLabel?.textAlignment = NSTextAlignment.center
               //        let numberButton = cell.viewWithTag(1) as! UIButton
               //        numberButton.titleLabel?.text = randomNumber[indexPath.row]
               return cell
    }
    

    
}
