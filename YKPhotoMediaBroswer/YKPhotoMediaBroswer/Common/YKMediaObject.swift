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
    var thumbImage:UIImage? //缩率图
    var path:String?  //图片路径可本地、可远程
    var vedioPath:String? //视频路径可本地、可远程
    var isFullScreen:Bool = false  //视频是否全屏
    var imageAsset:PHAsset?  //相册资源
    var index:Int = 0  // 索引，私有参数，对比标记当前页是否显示
    var fromView:UIView?  //点击的控件，用来产生视图出现或移出动画
}
