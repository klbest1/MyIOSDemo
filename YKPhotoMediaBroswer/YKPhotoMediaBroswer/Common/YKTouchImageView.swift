//
//  YKTouchImageView.swift
//  YKPhotoMediaBroswer
//
//  Created by kang lin on 2018/2/26.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit
import Photos
import AVKit
import AVFoundation

typealias GetImageComplete = (UIImage)->()
typealias GetVedioComplete = ()->()
typealias ImageProgress = (CGFloat)->()

class YKTouchImageView: FLAnimatedImageView {
    
    var imageComplete:GetImageComplete?
    var vedioComplete:GetVedioComplete?
    var progressClouser:ImageProgress?
    var playerViewController:AVPlayerViewController?
    fileprivate var assetRequestID:PHImageRequestID?
    fileprivate var vedioLayer:AVPlayerLayer?
    fileprivate var vedioImage:UIImage?
    
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
    
    //设置图片
    func setImage(path:String,hideProgress:Bool? = false)  {
        if path.hasPrefix("http") {
            self.sd_setImage(with: URL(string: path), placeholderImage: nil, options: .retryFailed, progress: { [weak self] (receivedSize, expectedSize, url) in
                
                if self?.progressClouser != nil && !hideProgress!{
                    self?.progressClouser!(CGFloat( receivedSize)/CGFloat(expectedSize ))
                }
                //            print("progress\(self?.progressView.progress ?? 0.0)")
            }) {  [weak self] (image, error, cache, url) in
                self?.vedioImage = image;
                DispatchQueue.main.async {
                    //                self.animatedImage = image
                    if (self?.imageComplete != nil && image != nil) {
                        self?.imageComplete!(image!)
                    }
                }
            }
        }else if path.hasPrefix("/var/"){
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
    
    /**/
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
    
    //播放视频
    func setVedio(path:String,thumbImagePath:String)  {
        //设置视频缩略图
        if !thumbImagePath.isEmpty {
            setImage(path: thumbImagePath, hideProgress: true)
        }
        
        if playerViewController == nil {
            playerViewController = AVPlayerViewController()
            playerViewController?.allowsPictureInPicturePlayback = false
            playerViewController?.showsPlaybackControls = false
        }

        var vedioURL = URL(string: path)
        if path.hasPrefix("/var/") ||  path.hasPrefix("/Users/"){
            vedioURL =   URL(fileURLWithPath: path)
        }
        
        guard vedioURL != nil else {
            return
        }
        
        if path.hasPrefix("http") {
            //  先获取缓存
            if let cachePathURL = YKMediaFileHandler.getCacheURLPath(path: path){
                self.image = nil;
                vedioURL =   cachePathURL
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.playVedioAtURL(vedioURL: cachePathURL)
                    self.playerViewController?.player?.play()
                })
                self.vedioComplete?()

            }else{
                //下载并播放
                let configureation = URLSessionConfiguration.default
                let seessionManager = AFURLSessionManager(sessionConfiguration: configureation)
                let request = URLRequest(url: vedioURL!)
                let task = seessionManager.downloadTask(with: request, progress: { (progress) in
                    self.progressClouser?(CGFloat(progress.fractionCompleted))
                }, destination: { (url, response) -> URL in
                    let filePath = YKMediaFileHandler.getMediaVedioSavePath()
                    return URL(fileURLWithPath: filePath).appendingPathComponent(response.suggestedFilename!)
                }, completionHandler: { (response, url, error) in
                    self.image = nil;
                    YKMediaFileHandler.cacheURLPath(path: vedioURL!.absoluteString, vedioName: response.suggestedFilename!);
                    let filePath = YKMediaFileHandler.getMediaVedioSavePath()
                    let localVedioURL =  URL(fileURLWithPath: filePath).appendingPathComponent(response.suggestedFilename!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        self.playVedioAtURL(vedioURL: localVedioURL)
                        self.playerViewController?.player?.play()
                    })
                    self.vedioComplete?()
                })
                task.resume()
            }
           
        }else{
            playVedioAtURL(vedioURL: vedioURL!)
            self.playerViewController?.player?.play()
        }
       
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(playDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playDidEnd), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playDidEnd), name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: nil)

    }
    
    func playVedioAtURL(vedioURL:URL)  {
        let playItem = AVPlayerItem(url: vedioURL)
        let tempPlayer = AVPlayer(playerItem: playItem)
        let playerLayer = AVPlayerLayer(player: tempPlayer)
        vedioLayer = playerLayer
        playerLayer.videoGravity = .resizeAspectFill
        self.playerViewController?.player = tempPlayer
        self.layer.addSublayer(playerLayer)
        
        //主动布局一次
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    @objc func playDidEnd(){
        self.playerViewController?.player?.seek(to: CMTimeMake(0, 1))
        self.playerViewController?.player?.play()
    }
}
