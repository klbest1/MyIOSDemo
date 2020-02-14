//
//  HeaderView.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/8.
//  Copyright © 2019 TW. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var avartar: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func setHeader(_ userInfo:UserInfo)  {
        self.profileImageView.setWImage(urlStr: userInfo.profile_image)
        self.avartar.setWImage(urlStr: userInfo.avatar)
        self.nickNameLabel.text = userInfo.nick;
    }
}
