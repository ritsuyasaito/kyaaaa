//
//  UserTabmanViewController.swift
//  kyaaaa
//
//  Created by 齋藤律哉 on 2020/03/04.
//  Copyright © 2020 ritsuya. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class UserTabmanViewController: TabmanViewController {
    
    private lazy var viewControllers: [UIViewController] = {
        [
            storyboard!.instantiateViewController(withIdentifier: "kyaaaaViewController"),
            storyboard!.instantiateViewController(withIdentifier: "femaleViewController"),
            storyboard!.instantiateViewController(withIdentifier: "selfPostViewController"),
            
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self

           //tabmanの宣言
           let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap

        addBar(bar, dataSource: self, at: .top)

        // Do any additional setup after loading the view.
    }
    


}


extension UserTabmanViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {

        let titilename = ["kyaaaa(男)","kyaaaa(女)","投稿履歴"]
        var items = [TMBarItem]()

        for i in titilename {
            let title = TMBarItem(title: i)
            items.append(title)
        }
        return items[index]
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for tabViewController: TabmanViewController, at index: Int) -> TMBarItemable {
        let title = "Page \(index)"
        return TMBarItem(title: title)
    }
}
