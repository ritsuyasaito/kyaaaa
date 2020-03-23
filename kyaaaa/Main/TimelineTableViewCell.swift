//
//  TimelineTableViewCell.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/03/02.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit


//potocol宣言
protocol TimeLineTableViewCellDelegate {
    func didTapSorenaButton(tableViewCell: UITableViewCell, button: UIButton)
    func didTapNaruhodoButton(tableViewCell: UITableViewCell, button: UIButton)
    func didTapKyaaaaButton(tableViewCell: UITableViewCell, button: UIButton)
    func didTapShareButton(tableViewCell: UITableViewCell, button: UIButton)
    
    
}



class TimelineTableViewCell: UITableViewCell {
    
    //宣言したprotocolを継承したプロパティを定義
    var delegate: TimeLineTableViewCellDelegate?
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var initialLabel: UILabel!
    @IBOutlet var fromNameLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var sorenaButton: UIButton!
    @IBOutlet var sorenaCountLabel: UILabel!
    @IBOutlet var naruhodoButton: UIButton!
    @IBOutlet var naruhodoCountLabel: UILabel!
    @IBOutlet var kyaaaaButton: UIButton!
    @IBOutlet var kaaaaaCountLabel: UILabel!
    @IBOutlet var baseView: UIView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.clipsToBounds = true
//        layer.cornerRadius = 20
//        layer.masksToBounds = true
//        layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
//        //      cell.layer.shadowOffset = CGSizeMake(0, 0)
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.23
//        layer.shadowRadius = 10
        
        
        baseView.layer.cornerRadius = 8.0
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        baseView.layer.shadowOpacity = 0.2
        baseView.layer.shadowRadius = 4.0
        baseView.layer.masksToBounds = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //sorenaボタンを押されたときにお呼ばれる
    @IBAction func sorenaButton(button: UIButton) {
        //protocolのメソッドをここで発動、引数にこのtableViewcellとsorenaButtonにする
        self.delegate?.didTapSorenaButton(tableViewCell: self, button: button)
    }
    
    @IBAction func naruhodoButton(button: UIButton) {
        self.delegate?.didTapNaruhodoButton(tableViewCell: self, button: button)
    }
    
    @IBAction func kyaaaaButton(button: UIButton) {
        self.delegate?.didTapKyaaaaButton(tableViewCell: self, button: button)
    }
    
    @IBAction func shareButton(button: UIButton) {
        self.delegate?.didTapShareButton(tableViewCell: self, button: button)
    }
    
}
