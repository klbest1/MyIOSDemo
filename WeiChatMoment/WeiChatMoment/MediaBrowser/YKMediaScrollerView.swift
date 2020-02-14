//
//  YKMediaScrollerView.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/7.
//  Copyright © 2019 TW. All rights reserved.
//

import UIKit

protocol YKMediaScrollerViewDelegate:class {
}

class YKMediaScrollerView: UIView {
    
    //currenIndex if 0,it's 0+1
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func showBroswer(dataSource:[YKMediaObject],atIndex:Int){
        let mediaScroolerView = YKMediaScrollerView(frame: UIScreen.main.bounds)
        UIApplication.shared.windows[0].addSubview(mediaScroolerView)
        mediaScroolerView.setDataSouce(dataSource: dataSource, currentIndex: atIndex)
    }
    
    func disMissBroswer()  {
        self.removeFromSuperview()
    }
    
    fileprivate func setDataSouce(dataSource:[YKMediaObject],currentIndex:Int)  {
        //
        if(dataSource.count == 0){
            print("setDataSouce can\'t be empty")
            return
        }
        
        if(dataSource.count < (currentIndex - 1)){
            print("setDataSouce current Index is beyond range")
            return
        }
        self.currentIndex = currentIndex
        self.dataSoucre = dataSource;
        self.numberOfPages = dataSource.count;
        
        //create pagenation
        let pageConfig = PageDotConfig()
        pageConfig.numberOfPages = CGFloat(self.numberOfPages)
        pageConfig.currentPage = CGFloat(currentIndex)
        pageController = YKPageDotContol(config: pageConfig)
        pageController.addTarget(self, action: #selector(pageValueChanged(_:)), for: .valueChanged)
        if dataSource.count == 1{pageController.isHidden = true}
        self.addSubview(pageController)
        
        scrollerView.contentSize = CGSize(width: (self.bounds.size.width + PagePadding * 2) *  CGFloat( dataSource.count ), height: self.bounds.size.height)
        
        self.layoutIfNeeded()
        //move to the index page
        animateAtFirstShowOut = true;
        scrollToPageAtIndex(index: currentIndex-1,animate: false)
    }
    
    fileprivate func scrollToPageAtIndex(index:Int,animate:Bool)  {
        let currentOffestX = CGFloat(index) * scrollerView.bounds.size.width
        scrollerView.setContentOffset(CGPoint(x:currentOffestX,y:0), animated: animate)
        if currentOffestX == 0 {
            self.scrollViewDidScroll(scrollerView)
        }
    }
    
    //show page at index
    func displayAtIndex(index:Int)  {
        let mediaInfo = dataSoucre[index]
        mediaInfo.index = index
        let zoomerAtIndex = getZoomerAtIndex(index: index)
        zoomerAtIndex?.setItem(object: mediaInfo)
    }
    
    //reset the images not visible
    func resetZoomerAtIndex(index:Int)  {
        for zoomer in visibleZoomer{
            if zoomer.index == index  {
                let mediaInfo = dataSoucre[index];
                zoomer.setItem(object: mediaInfo)
            }
        }
    }
    
    
    //get page at the index
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
        //firt show animation
        if visibleZoomer.count == 0 && animateAtFirstShowOut && !item.isFullScreen{
            zoomerView.animateAtFirstShowOut = animateAtFirstShowOut
            animateAtFirstShowOut = false
        }
        scrollerView.addSubview(zoomerView)
        zoomerView.frame = getAddRoomRect(index: item.index)
        zoomerView.setItem(object: item)
        //remove the browser
        zoomerView.zoomerDidDismiss = {
             [weak self] in
            self?.disMissBroswer()
        }
        //will remove broswer
        zoomerView.zoomerWillDismiss = {
            [weak self] in
            self?.backgroundColor = UIColor.clear
            self?.pageController.isHidden = true;
            self?.isUserInteractionEnabled = false;
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
        
        var firstIndex = Int(scrollView.bounds.minX/scrollView.bounds.size.width);
        if firstIndex < 0 {
            firstIndex = 0
        }
        
        var lastIndex = Int((scrollView.bounds.maxX - 10)/scrollView.bounds.size.width)
        if lastIndex > self.numberOfPages - 1 {
            lastIndex = self.numberOfPages - 1
        }
        
        //recycle page not visible
        for zoomItem in visibleZoomer{
            if zoomItem.index < firstIndex || zoomItem.index > lastIndex {
                zoomItem.clearContent()
                reuseableZoomber.append(zoomItem)
            }
        }
        
        //refresh visible pages
        visibleZoomer = visibleZoomer.filter{
             !self.reuseableZoomber.contains($0)
        }
        
        //add visible pages to screen
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
