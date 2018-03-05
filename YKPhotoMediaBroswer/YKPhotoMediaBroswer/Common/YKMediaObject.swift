//
//  YKMediaObject.swift
//  YKPhotoMediaBroswer
//
//  Created by kang lin on 2018/2/27.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit
import Photos

class YKMediaObject: NSObject {
    var path:String?
    var vedioPath:String?
    var imageAsset:PHAsset?
    var index:Int = 0
    var fromView:UIView?
}
