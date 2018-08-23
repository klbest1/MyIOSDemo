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
        let config = BageConfig()
        config.backGroundColor = UIColor.orange
        config.txtFront = UIFont.systemFont(ofSize: 10)
        config.txtColor = UIColor.white
        
        badgeView.frame = CGRect(x: 150, y: 300, width: 150, height: 150)
        badgeView.setBadgeNumber(num: "28",config: config)
        badgeView.finishBolock = {
            (finish:Bool) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.badgeView.setBadgeNumber(num: "310+",config:config)
            })
        }
        self.view.addSubview(badgeView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

