//
//  ViewController.swift
//  BadgeView
//
//  Created by kang lin on 2018/1/22.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let badgeView = YKBadgeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        badgeView.frame = CGRect(x: 150, y: 300, width: 50, height: 50)
        badgeView.setBadgeNumber(num: "99+")
        badgeView.finishBolock = {
            (finish:Bool) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.badgeView.setBadgeNumber(num: "109+")
            })
        }
        self.view.addSubview(badgeView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

