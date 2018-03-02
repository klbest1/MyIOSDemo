//
//  YKGifButton.swift
//  YKPhotoMediaBroswer
//
//  Created by kang lin on 2018/3/2.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit

class YKGifButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let gifImageView = FLAnimatedImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(gifImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
     func setImage(url: URL) {
        gifImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "gray"), options: .retryFailed, completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gifImageView.frame = self.bounds
        
    }

}
