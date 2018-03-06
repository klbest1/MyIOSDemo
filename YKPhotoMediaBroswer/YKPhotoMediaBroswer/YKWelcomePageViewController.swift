//
//  YKWelcomePageViewController.swift
//  YKPhotoMediaBroswer
//
//  Created by kang lin on 2018/3/6.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit

class YKWelcomePageViewController: UIViewController {

    let zoomImageView = YKTouchImageView(frame: CGRect.zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景图为空时，默认为全屏幕大小
            zoomImageView.frame = self.view.bounds
            self.view.addSubview(zoomImageView)
        self.view.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }
    
    func setVedio(ob:YKMediaObject)  {
        zoomImageView.setVedio(path: ob.vedioPath ?? "", thumbImagePath: "")
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
