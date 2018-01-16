//
//  YKDetailViewController.swift
//  ZoomAndCropperImage
//
//  Created by kang lin on 2018/1/5.
//  Copyright © 2018年 超凡股份. All rights reserved.
//

import UIKit

class YKDetailViewController: UIViewController {

     var imageView: UIImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        imageView.center = self.view.center;
        self.view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
