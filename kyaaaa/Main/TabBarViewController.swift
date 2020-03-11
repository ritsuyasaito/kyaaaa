//
//  TabBarViewController.swift
//  kyaaaa
//
//  Created by 藤田えりか on 2020/03/11.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class TabBarViewController: RAMItemAnimation {

    override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playBounceAnimation(icon)
        textLabel.textColor = textSelectedColor
    }

    override func deselectAnimation(_ icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
        textLabel.textColor = defaultTextColor
    }

    override func selectedState(_ icon: UIImageView, textLabel: UILabel) {
        textLabel.textColor = textSelectedColor
    }

    func playBounceAnimation(_ icon : UIImageView) {

        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic

        icon.layer.add(bounceAnimation, forKey: "bounceAnimation")
    }

}
