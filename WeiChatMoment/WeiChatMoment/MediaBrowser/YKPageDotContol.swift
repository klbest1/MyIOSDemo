//
//  YKPageDotContoller.swift
//  WeiChatMoment
//
//  Created by lin kang on 2019/11/7.
//  Copyright © 2019 TW. All rights reserved.
//
import UIKit

enum PageStyle:Int{
    case DefaultStyle = 1,
    NormFilledStyle = 3,
    ImageStyle = 2
}

class PageDotConfig{
    //color
    var normalCollor:UIColor = UIColor.gray
    var selectedColor:UIColor = UIColor.lightGray
    //size
    var radiusWidth:CGFloat = 3
    var strokeWidth:CGFloat = 1
    var spaceWidth:CGFloat = 10
    //numbers
    var numberOfPages:CGFloat = 5
    var currentPage:CGFloat = 1
    
//    var normalImage:UIImage = #imageLiteral(resourceName: "round2")
//    var selectedImage:UIImage = #imageLiteral(resourceName: "round1")
}

class YKPageDotContol: UIControl {

    var pageConfig:PageDotConfig!{
        didSet{
            
        }
    }
    var pageStyle:PageStyle = PageStyle.DefaultStyle
    
    var currentPage:CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    init(config:PageDotConfig) {
        let controllerWidth = (config.radiusWidth * 2 + config.strokeWidth * 2 + config.spaceWidth) * config.numberOfPages -  config.spaceWidth
        let contollerHeight = (config.radiusWidth * 2 + config.strokeWidth * 2)
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: controllerWidth, height: contollerHeight))
        super.init(frame: frame)
        self.pageConfig = config
        self.backgroundColor = UIColor.clear
        currentPage = pageConfig.currentPage
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(taping));
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    @objc func taping(_ sender:UITapGestureRecognizer)  {
        let touchPoint = sender.location(in: self)
        let circleWidth = pageConfig.strokeWidth*2 + pageConfig.radiusWidth * 2
        let itemWidth = (pageConfig.spaceWidth + circleWidth)
        let currentMiniX = (currentPage-1) * itemWidth - pageConfig.spaceWidth
        let currentMaxX = currentMiniX + itemWidth
        //click at left of current page
        if touchPoint.x < currentMiniX {
            currentPage -= 1
            if currentPage < 1 {
                currentPage = 1
            }
        //click at the right of current page
        }else if (touchPoint.x > currentMaxX){
            currentPage += 1
            if currentPage > pageConfig.numberOfPages  {
                currentPage = pageConfig.numberOfPages
            }
        }
        
        self.setNeedsDisplay()
        self.sendActions(for: .valueChanged)
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
 
        for i in  0..<Int(pageConfig.numberOfPages){
            let circleWidth = pageConfig.strokeWidth*2 + pageConfig.radiusWidth * 2
            let itemWidth = (pageConfig.spaceWidth + circleWidth)
            let offsetX = CGFloat( i ) * itemWidth;
            let offSetY:CGFloat = 0;
            let dotRect = CGRect(x: offsetX, y: offSetY, width: circleWidth, height: circleWidth)
            if pageStyle == .DefaultStyle {
                let path = UIBezierPath(ovalIn: dotRect)
                pageConfig.selectedColor.setFill()
                pageConfig.normalCollor.setStroke()
                if i == Int(currentPage - 1) {
                    path.fill()
                }
                path.stroke()
            }
//            else if(pageStyle == .ImageStyle){
//                if i == Int(currentPage - 1) {
//                    pageConfig.selectedImage.draw(in: dotRect)
//                }else{
//                    pageConfig.normalImage.draw(in: dotRect)
//                }
//            }
            else if(pageStyle == .NormFilledStyle){
                let path = UIBezierPath(ovalIn: dotRect)
                if i == Int(currentPage - 1) {
                    pageConfig.selectedColor.setFill()
                }else{
                    pageConfig.normalCollor.setFill()
                }
                path.fill()
            }
        }
    }

}
