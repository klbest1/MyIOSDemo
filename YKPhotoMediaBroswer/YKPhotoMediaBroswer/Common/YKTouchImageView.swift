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
    fileprivate var assetRequestID:PHImageRequestID?
    fileprivate var playerViewController:AVPlayerViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
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
    
    //播放视频
    func setVedio(path:String)  {
        if playerViewController == nil {
            playerViewController = AVPlayerViewController()
            playerViewController?.allowsPictureInPicturePlayback = false
            playerViewController?.showsPlaybackControls = false
        }

        var vedioURL = URL(string: path)
        if path.hasPrefix("/var/"){
            vedioURL =   URL(fileURLWithPath: path)
        }
        
        guard vedioURL != nil else {
            return
        }
        
        if path.hasPrefix("http") {
            if let cachePath = YKMediaFileHandler.getCacheURLPath(path: path){
                vedioURL =   URL(fileURLWithPath: cachePath)
                playVedioAtURL(vedioURL: vedioURL!)
            }else{
                let configureation = URLSessionConfiguration.default
                let seessionManager = AFURLSessionManager(sessionConfiguration: configureation)
                let request = URLRequest(url: vedioURL!)
                seessionManager.downloadTask(with: request, progress: { (progress) in
                    self.progressClouser?(CGFloat(progress.fractionCompleted))
                }, destination: { (url, response) -> URL in
                    let filePath = YKMediaFileHandler.getMediaVedioSavePath()
                    return URL(fileURLWithPath: filePath).appendingPathComponent(response.suggestedFilename!)
                }, completionHandler: { (response, url, error) in
                    YKMediaFileHandler.cacheURLPath(path: url!.absoluteString, vedioName: response.suggestedFilename!);
                    let filePath = YKMediaFileHandler.getMediaVedioSavePath()
                    let localVedioURL =  URL(fileURLWithPath: filePath).appendingPathComponent(response.suggestedFilename!)
                    self.playVedioAtURL(vedioURL: localVedioURL)
                    self.playerViewController?.player?.play()
                    self.vedioComplete?()
                })
            }
           
        }else{
            playVedioAtURL(vedioURL: vedioURL!)
        }
       
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(playDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func playVedioAtURL(vedioURL:URL)  {
        let playItem = AVPlayerItem(url: vedioURL)
        let tempPlayer = AVPlayer(playerItem: playItem)
        let playerLayer = AVPlayerLayer(player: tempPlayer)
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspect
        self.playerViewController?.player = tempPlayer
        self.layer.addSublayer(playerLayer)
    }
    
    @objc func playDidEnd(){
        self.playerViewController?.player?.seek(to: CMTimeMake(0, 1))
        self.playerViewController?.player?.play()
    }
}
