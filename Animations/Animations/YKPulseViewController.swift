//
//  YKPulseViewController.swift
//  Animations
//
//  Created by kang lin on 2018/1/16.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit

class YKPulseViewController: UIViewController {

    let button:UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "脉冲动画";
        // Do any additional setup after loading the view.
//        button.image = #imageLiteral(resourceName: "customer_160.png")
        button.setImage(#imageLiteral(resourceName: "customer_160.png"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        button.center = self.view.center;
        button.isUserInteractionEnabled = true;
        button.addTarget(self, action: #selector(btClicked(_:)), for: .touchUpInside);
        self.view.addSubview(button);
        self.view.backgroundColor = UIColor.white;
//        let tap =  UITapGestureRecognizer(target: self, action: #selector(btClicked(_:)))
//        button.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func btClicked(_ sender:UITapGestureRecognizer)  {
        let pluseLayer = YQPulaseAnimation(radius: button.bounds.size.width/2 + 30, animationDurantion: 0.5, tpositon: button.center)
        button.layer.superlayer?.insertSublayer(pluseLayer, below: button.layer);
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
