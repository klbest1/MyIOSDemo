//
//  CommentInfo.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/7.
//  Copyright © 2019 TW. All rights reserved.
//

import UIKit
import HandyJSON

class CommentInfo: HandyJSON {
    
    var content: String?
    var sender: SenderInfo?
    
    required init() {
        
    }
}
