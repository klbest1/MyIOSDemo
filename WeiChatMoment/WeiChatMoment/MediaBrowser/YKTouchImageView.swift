//
//  YKTouchImageView.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/7.
//  Copyright © 2019 TW. All rights reserved.
//

import UIKit
import Photos
import AVKit
import AVFoundation

typealias GetImageComplete = (UIImage)->()
typealias GetVedioComplete = ()->()
typealias ImageProgress = (CGFloat)->()


class YKTouchImageView: UIImageView {
    
    var imageComplete:GetImageComplete?
    var vedioComplete:GetVedioComplete?
    var progressClouser:ImageProgress?
    var playerViewController:AVPlayerViewController?
    fileprivate var assetRequestID:PHImageRequestID?
    fileprivate var vedioLayer:AVPlayerLayer?
    fileprivate var vedioImage:UIImage?
    fileprivate var totalSize:Int = 1000000
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        vedioLayer?.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //set the image
    func setImage(path:String,hideProgress:Bool? = false)  {
        if path.hasPrefix("http") {
            // downloadimage
            DownLoadImageHelper.sharedInstance.loadImage(urlString:path, completionHandler: { [weak self] (image, url) in
                self?.image = image
                self?.imageComplete?(image ?? UIImage())
            } )
        }else if path.hasPrefix("/var/") || path.hasPrefix("/Users/"){
            self.image = UIImage(contentsOfFile: path)
            self.vedioImage = image;
            self.imageComplete?(image ?? UIImage())
        }
     
    }
    
    func clear()  {
        self.frame = CGRect.zero
        self.image = nil
        hideVedio()
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func hideVedio()  {
        self.image = vedioImage
        self.vedioLayer?.removeFromSuperlayer()
        self.playerViewController?.player?.pause()
        self.playerViewController?.player = nil
        self.vedioLayer = nil
        self.playerViewController = nil
    }
    
    
   //从相册加载资源
    func setImage(asset:PHAsset)  {
        let imageManager = PHImageManager.default()
        let imageRequestOption = PHImageRequestOptions()
        imageRequestOption.isNetworkAccessAllowed = true
        imageRequestOption.resizeMode = .fast
        imageRequestOption.deliveryMode = .highQualityFormat
        imageRequestOption.isSynchronous = false
        imageRequestOption.progressHandler = {
          (progress,error,stop,info)  in
            self.progressClouser?(CGFloat(progress))
        }
        self.assetRequestID = imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: imageRequestOption, resultHandler: { (image, info) in
            self.image = image;
            self.imageComplete?(image ?? UIImage())
        })
    }
    
}
