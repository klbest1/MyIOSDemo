//
//  YKTouchImageView.swift
//  YKPhotoMediaBroswer
//
//  Created by kang lin on 2018/2/26.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit
import Photos

typealias GetImageComplete = (UIImage)->()
typealias ImageProgress = (CGFloat)->()

class YKTouchImageView: FLAnimatedImageView {
    
    var imageComplete:GetImageComplete?
    var progressClouser:ImageProgress?
    fileprivate var assetRequestID:PHImageRequestID?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //模糊图片怎么加的？
    func setImage(path:String)  {
        if path.hasPrefix("http") {
            self.sd_setImage(with: URL(string: path), placeholderImage: nil, options: .retryFailed, progress: { [weak self] (receivedSize, expectedSize, url) in
                
                if self?.progressClouser != nil{
                    self?.progressClouser!(CGFloat( receivedSize)/CGFloat(expectedSize ))
                }
                //            print("progress\(self?.progressView.progress ?? 0.0)")
            }) { (image, error, cache, url) in
                DispatchQueue.main.async {
                    //                self.animatedImage = image
                    if (self.imageComplete != nil && image != nil) {
                        self.imageComplete!(image!)
                    }
                }
            }
        }else if path.hasPrefix("/var/"){
            self.image = UIImage(contentsOfFile: path)
            self.imageComplete?(image ?? UIImage())
        }
     
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
