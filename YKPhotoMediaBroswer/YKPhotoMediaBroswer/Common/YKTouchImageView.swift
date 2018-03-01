//
//  YKTouchImageView.swift
//  YKPhotoMediaBroswer
//
//  Created by kang lin on 2018/2/26.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit

typealias GetImageComplete = (UIImage)->()
typealias ImageProgress = (CGFloat)->()

class YKTouchImageView: UIImageView {
    
    var imageComplete:GetImageComplete?
    var progressClouser:ImageProgress?
    
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
        self.sd_setImage(with: URL(string: path), placeholderImage: nil, options: .retryFailed, progress: { [weak self] (receivedSize, expectedSize, url) in

            if self?.progressClouser != nil{
                self?.progressClouser!(CGFloat( receivedSize)/CGFloat(expectedSize ))
            }
//            print("progress\(self?.progressView.progress ?? 0.0)")
        }) { (image, error, cache, url) in
            DispatchQueue.main.async {
                self.image = image
                if (self.imageComplete != nil && image != nil) {
                    self.imageComplete!(image!)
                }
            }
        }
    }
}
