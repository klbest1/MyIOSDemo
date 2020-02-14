//
//  UserInfo.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/7.
//  Copyright © 2019 TW. All rights reserved.
//

import UIKit
import HandyJSON

class UserInfo: HandyJSON {
    var username: String?
    var nick: String?
    var avatar: String?
    var profile_image:String?
    
    required init() {
        
    }
    
    func mapping(mapper: HelpingMapper) {
        // specify 'profile_image' field in json map to 'profile-image' property in object
        mapper <<<
            self.profile_image <-- "profile-image"
    }
}
