//
//  YKMediaScrollerView.swift
//  YKPhotoMediaBroswer
//
//  Created by kang lin on 2018/2/27.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit

enum ScrollDirection:Int{
    case Left = 1,
    Right = 2,
    Current = 3,
    None = 4
    
}

protocol YKMediaScrollerViewDelegate:class {
}

class YKMediaScrollerView: UIView {
    
    //这两个index是相对于用户，不是数组索引
    fileprivate var currentIndex = 1
    fileprivate var preIndex = -1
    
    fileprivate let scrollerView = UIScrollView()
    fileprivate var visibleZoomer:[YKMediaZoomView] = [YKMediaZoomView]()
    fileprivate var reuseableZoomber:[YKMediaZoomView] = [YKMediaZoomView]()
    fileprivate var numberOfPages:Int = 0
    fileprivate var dataSoucre:[YKMediaObject]!
    fileprivate var pageController:YKPageDotContol!
    fileprivate var animateAtFirstShowOut = false
    
    let PagePadding:CGFloat = 10;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollerView.isPagingEnabled = true;
        scrollerView.delegate = self
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.backgroundColor = UIColor.black
        self.addSubview(scrollerView)
        
        SDWebImageCodersManager.sharedInstance().addCoder(SDWebImageGIFCoder.shared())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func showBroswer(dataSource:[YKMediaObject],atIndex:Int){
        let mediaScroolerView = YKMediaScrollerView(frame: UIScreen.main.bounds)
        UIApplication.shared.keyWindow?.addSubview(mediaScroolerView)
//        UIApplication.shared.statusBarStyle = .lightContent
        mediaScroolerView.setDataSouce(dataSource: dataSource, currentIndex: atIndex)
    }
    
    func disMissBroswer()  {
        self.removeFromSuperview()
    }
    
    fileprivate func setDataSouce(dataSource:[YKMediaObject],currentIndex:Int)  {
        self.currentIndex = currentIndex
        self.dataSoucre = dataSource;
        self.numberOfPages = dataSource.count;
        //创建页面指示
        let pageConfig = PageDotConfig()
        pageConfig.numberOfPages = CGFloat(self.numberOfPages)
        pageConfig.currentPage = CGFloat(currentIndex)
        pageController = YKPageDotContol(config: pageConfig)
        pageController.addTarget(self, action: #selector(pageValueChanged(_:)), for: .valueChanged)
        if dataSource.count == 1{pageController.isHidden = true}
        self.addSubview(pageController)
        
        scrollerView.contentSize = CGSize(width: (self.bounds.size.width + PagePadding * 2) *  CGFloat( dataSource.count ), height: self.bounds.size.height)
        
        self.layoutIfNeeded()
        //滑倒当前页面去
        scrollToPageAtIndex(index: currentIndex-1,animate: false)
        animateAtFirstShowOut = true;
    }
    
    fileprivate func scrollToPageAtIndex(index:Int,animate:Bool)  {
        let currentOffestX = CGFloat(index) * scrollerView.bounds.size.width
        scrollerView.setContentOffset(CGPoint(x:currentOffestX,y:0), animated: animate)
        if currentOffestX == 0 {
            self.scrollViewDidScroll(scrollerView)
        }
    }
    
    //设置视图显示
    func displayAtIndex(index:Int)  {
        let mediaInfo = dataSoucre[index]
        mediaInfo.index = index
        let zoomerAtIndex = getZoomerAtIndex(index: index)
        zoomerAtIndex?.setItem(object: mediaInfo)
    }
    
    //重设之前滑过且还存在的是图，
    func resetZoomerAtIndex(index:Int)  {
        for zoomer in visibleZoomer{
            if zoomer.index == index  {
                let mediaInfo = dataSoucre[index];
                zoomer.setItem(object: mediaInfo)
            }
        }
    }
    
    
    //获取索引下的该视图
    func getZoomerAtIndex(index:Int)->YKMediaZoomView?  {
        for zoomer in visibleZoomer{
            if zoomer.index == index{
                return zoomer
            }
        }
        return nil
    }

    fileprivate func dequeReuseAbleZoomber() -> YKMediaZoomView {
        var zoomerView = reuseableZoomber.first;
        if zoomerView == nil {
            zoomerView = YKMediaZoomView(frame: self.bounds)
        }else{
            reuseableZoomber.removeFirst()
        }
        
        return zoomerView!;
    }
    
    fileprivate  func getAddRoomRect(index:Int) -> CGRect {
        
        let addZoomerOffsetX = CGFloat(index) * self.scrollerView.bounds.size.width + PagePadding;
        let addZoomerRect = CGRect(x: addZoomerOffsetX, y: 0, width: self.bounds.size.width, height: self.bounds.height)
        return addZoomerRect
        
    }
    
    fileprivate func addZoomerAt(item:YKMediaObject)  {

        for zoomer in visibleZoomer{
            if zoomer.index == item.index{
                return;
            }
        }
        let zoomerView = dequeReuseAbleZoomber()
        //初次展开时，设置展开动画
        if visibleZoomer.count == 0 && animateAtFirstShowOut{
            zoomerView.animateAtFirstShowOut = animateAtFirstShowOut
            animateAtFirstShowOut = false
        }
        scrollerView.addSubview(zoomerView)
        zoomerView.frame = getAddRoomRect(index: item.index)
        zoomerView.setItem(object: item)
        //移除图片浏览控件
        zoomerView.zoomerDidDismiss = {
             [weak self] in
            self?.disMissBroswer()
        }
        //即将移除图片浏览控件
        zoomerView.zoomerWillDismiss = {
            [weak self] in
            self?.backgroundColor = UIColor.clear
            self?.pageController.isHidden = true;
        }
        visibleZoomer.append(zoomerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var scrollerFrame = self.bounds
        scrollerFrame.size.width += PagePadding * 2
        scrollerFrame.origin.x = -PagePadding
        scrollerView.frame = scrollerFrame
        pageController.center = CGPoint(x:  self.bounds.size.width/2, y: self.bounds.size.height - 60)
    }
    
    @objc func pageValueChanged(_ sender:YKPageDotContol)  {
        scrollToPageAtIndex(index: Int(sender.currentPage-1),animate: true)
    }
}

extension YKMediaScrollerView:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        print("bounds:\(scrollView.bounds)")
        var firstIndex = Int(scrollView.bounds.minX/scrollView.bounds.size.width);
        if firstIndex < 0 {
            firstIndex = 0
        }
        
        //减去10很精妙，这个可以使lastIndex为当前页，从而移除掉当前页以外的所有视图
        var lastIndex = Int((scrollView.bounds.maxX - 10)/scrollView.bounds.size.width)
        if lastIndex > self.numberOfPages - 1 {
            lastIndex = self.numberOfPages - 1
        }
        
        //回收不可见的视图
        for zoomItem in visibleZoomer{
            if zoomItem.index < firstIndex || zoomItem.index > lastIndex {
                zoomItem.clearContent()
                reuseableZoomber.append(zoomItem)
            }
        }
        
        //移除掉不可见的视图
        visibleZoomer = visibleZoomer.filter{
             !self.reuseableZoomber.contains($0)
        }
        
        //添加当前滑动时，可见的视图
        for i in firstIndex...lastIndex{
            let mediaInfo = dataSoucre[i]
            mediaInfo.index = i;
            addZoomerAt(item: mediaInfo)
        }
        
        self.currentIndex = Int((scrollerView.contentOffset.x + scrollerView.bounds.size.width/2) / scrollView.bounds.size.width + 1)
        if self.preIndex !=  self.currentIndex{
            //浏览的当前页数
        }
        self.preIndex = self.currentIndex
        
        pageController.currentPage = CGFloat(currentIndex);
        
    }
}
