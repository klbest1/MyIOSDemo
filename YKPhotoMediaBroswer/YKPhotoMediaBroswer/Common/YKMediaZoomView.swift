//
//  YKImageZoomView.swift
//  YKPhotoMediaBroswer
//
//  Created by kang lin on 2018/2/26.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit

struct  MediaType:OptionSet {
    public let rawValue:Int
    
    init(rawValue:Int) {
        self.rawValue = rawValue
    }
    
    static  let MediaTypeImage:MediaType = MediaType(rawValue: 1<<0)
    static let  MediaTypeVedio:MediaType = MediaType(rawValue: 1<<1)
    static let  MediaTypeNone:MediaType = MediaType(rawValue: 1<<2)

    static func findType(path:String) -> MediaType {
        let fileURL = URL(fileURLWithPath: path)
        let extention = fileURL.pathExtension.lowercased();
        let imageSuffix:Set<String> = ["png","jpg","jpeg","gif"];
        let vedioSuffix:Set<String> = ["avi", "rmvb","rm","asf" ,"divx", "mpg", "mpeg", "mpe", "wmv", "mp4", "mkv" ,"vob" ];
        if imageSuffix.contains(extention) {
            return MediaTypeImage;
        }else if vedioSuffix.contains(extention){
            return MediaTypeVedio;
        }
        
        return MediaTypeNone
    }
}

typealias ZoomerDidDismisClosure = ()->()
typealias ZoomerWillDismisClosure = ()->()

class YKMediaZoomView: UIView {
    //即将移除
    var zoomerWillDismiss:ZoomerWillDismisClosure?
    //移除时的回调
    var zoomerDidDismiss:ZoomerDidDismisClosure?
    // 当前索引
    var index:Int = 0
    //首次出现展开动画
    var animateAtFirstShowOut = false

    fileprivate let scrollView:UIScrollView = UIScrollView()
    fileprivate let zoomImageView:YKTouchImageView = YKTouchImageView(frame: CGRect.zero)
    //用来手势滑动计算位置
    fileprivate var imageZoomedFrame:CGRect?
    
    fileprivate var preGuestureTouch:CGPoint?
    fileprivate var panGuestureSouldReceiveTouch = false
    fileprivate var mediaOb:YKMediaObject?
    fileprivate var isZooming = false;
    
    var mediaType:MediaType?
    fileprivate var progressView : DACircularProgressView!
    fileprivate var sheet:LYSheetCustom?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        progressView = DACircularProgressView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        progressView.roundedCorners = 1;
        progressView.trackTintColor = UIColor.gray
        //        progressView.backgroundColor = UIColor.red
        progressView.isHidden = true
        self.addSubview(progressView)
        
        //图片加载进度
        zoomImageView.progressClouser = {
            (progress) in
            DispatchQueue.main.async {
                self.progressView.isHidden = false
                self.progressView.progress = progress
            }
            if progress >= 1.0 {
                self.progressView.isHidden = true;
            }
        }
        
        //图片完成加载
        zoomImageView.imageComplete = { (image) in
            self.scrollView.contentSize = image.size;
            self.zoomImageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            let widhtScale = self.bounds.size.width/image.size.width
            let hegithScale = self.bounds.size.height/image.size.height
            let miniScale = min(widhtScale, hegithScale)
            self.scrollView.minimumZoomScale = miniScale
            self.scrollView.maximumZoomScale = 1
            self.scrollView.zoomScale = miniScale
            self.scrollView.addSubview(self.zoomImageView)
            self.imageZoomedFrame = self.zoomImageView.frame;

            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
        
        self.backgroundColor = UIColor.black
        self.addSubview(scrollView)
        
        let panGuesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panning(_:)));
        panGuesture.delegate = self
        self.addGestureRecognizer(panGuesture)
        
        let singleTapGuesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapping(_:)));
        singleTapGuesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTapGuesture)
        
        let douleTapGuesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapping(_:)))
        douleTapGuesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(douleTapGuesture)
        singleTapGuesture.require(toFail: douleTapGuesture)
        
        let longTapGuesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapping(_:)))
        self.addGestureRecognizer(longTapGuesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //mark: -  手势
    @objc func panning(_ sender:UIPanGestureRecognizer)  {
        
        if sender.state == .began {
            
        }
        
        if sender.state == .changed  && imageZoomedFrame != nil{
            let translation = sender.translation(in: self);
            let movingDistance = sqrt(translation.x*translation.x + translation.y*translation.y)
            let movingCenter = CGPoint(x: imageZoomedFrame!.midX + translation.x, y: imageZoomedFrame!.midY + translation.y)
            let ratio = movingDistance/300.0

            zoomImageView.center = movingCenter
            var imageFrame = zoomImageView.frame
            var sizeRatio = 1-ratio
            if sizeRatio < 0.6{
                sizeRatio = 0.6
            }
            imageFrame.size.width = imageZoomedFrame!.size.width * (sizeRatio)
            imageFrame.size.height = imageZoomedFrame!.size.height * (sizeRatio)
            zoomImageView.frame = imageFrame;
            self.backgroundColor = UIColor.black.withAlphaComponent((1-ratio*3))
            self.superview?.backgroundColor = UIColor.black.withAlphaComponent((1-ratio*3))
        }
        
        if sender.state == .ended  && imageZoomedFrame != nil{
            if zoomImageView.center.y - imageZoomedFrame!.midY > 50{
                removePage()
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.zoomImageView.frame = self.imageZoomedFrame!
                    self.backgroundColor = UIColor.black.withAlphaComponent((1))
                    self.superview?.backgroundColor = UIColor.black.withAlphaComponent((1))
                })
            }
            
            preGuestureTouch = nil;
        }
        
    }
    
    @objc func tapping(_ gusture:UITapGestureRecognizer){
        removePage()
    }
    
    @objc func doubleTapping(_ guesture:UITapGestureRecognizer){
        if scrollView.zoomScale != 1 {
            scrollView.setZoomScale(1, animated: true)
        }else{
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    
    @objc func longTapping(_ guesture:UITapGestureRecognizer)  {
        if sheet == nil {
             sheet = LYSheetCustom(title: nil, delegate: self, cancelButtonTitle: "取消", otherButtonTitlesArray: ["保存到相册"])
        }
        if sheet?.isVisible == false{
            sheet?.show()
        }
    }
    
    //MARK:- 功能方法
    func removePage()  {
        //移除界面
        if self.zoomerWillDismiss != nil{
            self.zoomerWillDismiss!()
        }
        self.backgroundColor = UIColor.clear
        self.superview?.backgroundColor = UIColor.clear
//        self.scrollView.zoomScale = self.scrollView.minimumZoomScale
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            if let fromView = self.mediaOb?.fromView {
                let fromRect = fromView.convert(fromView.bounds, to: self.scrollView)
                self.zoomImageView.frame = fromRect;
            }
        }, completion: { (finish) in
            if self.zoomerDidDismiss != nil{
                self.zoomerDidDismiss!()
            }
        })
    }
    
    func setItem(object:YKMediaObject)  {
        self.mediaOb = object;
        self.scrollView.zoomScale = 1
        self.scrollView.maximumZoomScale = 1
        self.scrollView.minimumZoomScale = 1
        self.scrollView.contentSize = CGSize.zero
        self.index = object.index
        mediaType = MediaType.findType(path: object.path ?? "")
        if mediaType == MediaType.MediaTypeImage {
            zoomImageView.setImage(path: object.path ?? "")
        }
    }
    
    func clearContent()  {
        zoomImageView.image = nil;
    }
    
    
    func centerImage()  {
        var imageFrame = self.zoomImageView.frame
        if imageFrame.size.width < self.bounds.size.width {
            imageFrame.origin.x = (self.bounds.size.width - imageFrame.size.width)/2
        }else{
            imageFrame.origin.x = 0
        }
        
        if imageFrame.size.height < self.bounds.size.height {
            imageFrame.origin.y = (self.bounds.size.height - imageFrame.size.height)/2
        }else{
            imageFrame.origin.y = 0
        }
        zoomImageView.frame = imageFrame;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        self.scrollView.frame = self.bounds
        
        if animateAtFirstShowOut,  let fromView = self.mediaOb?.fromView,self.imageZoomedFrame != nil{
            //首次出现是否显示展开动画
            let fromRect = fromView.convert(fromView.bounds, to: self.scrollView)
            
            self.zoomImageView.frame = fromRect;
            UIView.animate(withDuration: 0.3, animations: {
                self.zoomImageView.frame = self.imageZoomedFrame!
                self.centerImage()
            }, completion: { (finish) in
                self.animateAtFirstShowOut = false;
            })
        }else{
            centerImage()
        }
    }
}

//MARK:- UIScrollViewDelegate

extension YKMediaZoomView:UIScrollViewDelegate{
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if mediaType! == .MediaTypeImage {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        isZooming = true
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        imageZoomedFrame = self.zoomImageView.frame;
        isZooming = false
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomImageView
    }
}

//MARK:- 手势代理
extension YKMediaZoomView:UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{
 
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
     
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = gestureRecognizer.translation(in: self)
            if translation.y > 0 && !isZooming{
                return true
            }else{
                return false
            }
        }
        
        return true
    }
    
}

extension YKMediaZoomView:LYSheetCustomDelegate{
    func lySheetCustom(_ sheetCustom: LYSheetCustom!, clickedButtonAt buttonIndex: Int) {
        
    }
}
