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
    let playImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playImageView.image = #imageLiteral(resourceName: "PlayButtonOverlayLarge.png")
        playImageView.isHidden = true
        gifImageView.image = #imageLiteral(resourceName: "gray")
        self.addSubview(gifImageView)
        self.addSubview(playImageView)
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
        playImageView.frame = CGRect(x: 0, y: 0, width: #imageLiteral(resourceName: "PlayButtonOverlayLarge.png").size.width, height: #imageLiteral(resourceName: "PlayButtonOverlayLarge.png").size.height)
        playImageView.center = CGPoint(x: self.bounds.size.width/2, y:  self.bounds.size.height/2)
    }

}
