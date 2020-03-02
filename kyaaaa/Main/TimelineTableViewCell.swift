//
//  TimelineTableViewCell.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/03/02.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var initialLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var sorenaButton: UIButton!
    @IBOutlet var sorenaCountLabel: UILabel!
    @IBOutlet var naruhodoButton: UIButton!
    @IBOutlet var naruhodoCountLabel: UILabel!
    @IBOutlet var kyaaaaButton: UIButton!
    @IBOutlet var kaaaaaCountLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
