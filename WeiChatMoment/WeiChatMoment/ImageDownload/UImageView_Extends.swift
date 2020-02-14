//
//  File.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/8.
//  Copyright © 2019 TW. All rights reserved.
//

import UIKit


extension UIImageView {
    func setWImage(urlStr : String?,placeholder : UIImage? = nil){
        self.image = placeholder
        if urlStr == nil {
            return
        }
        //unvalidate url
        let url = URL(string: urlStr!)
        if url == nil {
            return
        }
        // downloadimage
        DownLoadImageHelper.sharedInstance.loadImage(urlString: urlStr!, completionHandler: { [weak self] (image, url) in
            self?.image = image
        } )
    }
    
}
