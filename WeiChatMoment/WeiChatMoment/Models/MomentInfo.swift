//
//  momentInfo.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/7.
//  Copyright © 2019 TW. All rights reserved.
//

import HandyJSON

class MomentInfo: HandyJSON {
    var content: String?
    var images: [IMageURL]?
    
    var sender:SenderInfo?
    var comments: [CommentInfo]?
    // whole cell height
    var cellHeight:CGFloat = 0;
    // sender's content label height
    var contentHeight:CGFloat = 0;
    // is need expand for all content text
    var isExpand = false;
    // is showing all text
    var isShowAll = false;
    // show all button height
    var showAllButtonHeight:CGFloat = 0;
    // collection view height
    var imageHeight:CGFloat = 0;
    // comments height
    var commentHeight:CGFloat = 0;
    
    required init() {
        
    }
}
