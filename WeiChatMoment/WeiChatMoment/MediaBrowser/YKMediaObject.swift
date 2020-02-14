//
//  YKMediaObject.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/7.
//  Copyright © 2019 TW. All rights reserved.
//

import UIKit
import Photos


enum FileOnlineType:Int {
    case Image,
    Voice,
    Vedio
}

class YKMediaObject: NSObject {
    // small image
    var thumbImage:UIImage?
    // big image
    var path:String?  
    var vedioPath:String?
    var isFullScreen:Bool = false
    // from album
    var imageAsset:PHAsset?
    var index:Int = 0
    // which view come from 
    var fromView:UIView?
}
