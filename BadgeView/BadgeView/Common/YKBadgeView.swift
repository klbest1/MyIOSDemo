//
//  YKBadgeView.swift
//  BadgeView
//
//  Created by kang lin on 2018/1/22.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit

enum BadgeStyle:Int {
    case Round = 1,
    CornerRadius = 2
}

typealias FinishBlock = (_ finish:Bool)->Void

class YKBadgeView: UIView {
    
    var badgeStyle = BadgeStyle.Round
    var finishBolock:FinishBlock?
    fileprivate  var backFontView:UIView = UIView()
    fileprivate var frontView:UIView = UIView()
    fileprivate var titleLabel:UILabel = UILabel()
    fileprivate var overLayView:UIView = UIView()
    fileprivate var bombView:UIImageView = UIImageView()
    fileprivate var curveLayer:CAShapeLayer = CAShapeLayer()
    fileprivate var originCenterPoint:CGPoint = CGPoint.zero
    fileprivate var springPoint = CGPoint.zero
    fileprivate var r1:CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        
        frontView.backgroundColor = UIColor.red
        backFontView.backgroundColor = UIColor.red
        backFontView.isHidden = true

        overLayView.backgroundColor = .clear;
        overLayView.frame = UIScreen.main.bounds
        
        self.addSubview(backFontView)
        self.addSubview(frontView)
        frontView.addSubview(titleLabel)
        let panGusture = UIPanGestureRecognizer(target: self, action: #selector(paning(_:)));
        self.addGestureRecognizer(panGusture);
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setBadgeNumber(num:String)  {
        titleLabel.text = num;
        layoutBadgeSubviews()
    }
    
    func findCurrentWindow() -> UIWindow? {
        for window in UIApplication.shared.windows.reversed(){
            if window.screen == UIScreen.main
                && window.alpha > 0
                && window.windowLevel == UIWindowLevelNormal{
                return window
            }
        }
        return nil;
    }
    
     func layoutBadgeSubviews() {
        frontView.isHidden = false;
        frontView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width , height: self.bounds.size.width )
        titleLabel.frame = frontView.frame
        backFontView.frame = frontView.frame
        originCenterPoint = backFontView.center;
        
        if badgeStyle == .CornerRadius {
            frontView.layer.cornerRadius = 5
            frontView.layer.masksToBounds = true;
            backFontView.layer.cornerRadius = 6
            backFontView.layer.masksToBounds = true;
        }else{
            frontView.layer.cornerRadius = max(frontView.bounds.size.height, frontView.bounds.size.width)/2.0
            backFontView.layer.cornerRadius = frontView.layer.cornerRadius
            backFontView.layer.masksToBounds = true;
            frontView.layer.masksToBounds = true;
        }
    }
   
    func drawRect(path:UIBezierPath)  {
        if backFontView.bounds.size.width > 5 {
            curveLayer.isHidden = false;
            curveLayer.path = path.cgPath
            curveLayer.fillColor = UIColor.red.cgColor
            overLayView.layer.insertSublayer(curveLayer, below:  frontView.layer)
        }else{
            curveLayer.removeFromSuperlayer()
        }
    }
    
    func disPlaySpringAnimation(startPoint:CGPoint)  {
        let animation = CASpringAnimation(keyPath: "position")
        animation.duration = animation.settlingDuration
        animation.fromValue = NSValue(cgPoint: startPoint)
        animation.toValue = NSValue(cgPoint: originCenterPoint)
        animation.initialVelocity = 70
        animation.mass = 0.5
        frontView.layer.add(animation, forKey: nil)
    }
    
    func showBombAnimation(touchPoint:CGPoint)  {
        bombView.frame = CGRect(x: 0, y: 0, width: frontView.bounds.size.width, height: frontView.bounds.size.width)
        bombView.center = touchPoint;
        var images = [UIImage]()
        for i in 0..<5{
            let image = UIImage(named: "bomb\(i)")
            images.append(image!)
        }
        bombView.animationImages = images
        bombView.animationDuration = 0.5
        bombView.animationRepeatCount = 1
        bombView.startAnimating();
        self.addSubview(bombView)
    }
    

    @objc func paning(_ sender:UIPanGestureRecognizer) {
        
        if sender.state == .began {
            frontView.layer.removeAllAnimations()
        }
        
        let miniR1:CGFloat = 5;
        let touchPoint = sender.location(in: self)

        if sender.state == .changed {
            var distance:CGFloat = 0.0
            let r2 = min(self.bounds.size.width, self.bounds.size.height)/2
            let originCenter =  backFontView.center;
            let doubleSqrt = (touchPoint.x - originCenter.x) * (touchPoint.x -  originCenter.x) + (touchPoint.y - originCenter.y) * (touchPoint.y - originCenter.y)
            distance = CGFloat(sqrt(doubleSqrt))
            r1 = r2

            if distance > 0{
                // 将前景加入全屏
                if overLayView.superview == nil{
                    let window = findCurrentWindow()
                    window?.addSubview(overLayView)
                }
                let touchePointInScreen = self.convert(touchPoint, to: overLayView)
                frontView.center = touchePointInScreen
                if frontView.superview != overLayView{
                    frontView.removeFromSuperview()
                    overLayView.addSubview(frontView)
                }
                
                //将背景变小
                r1 -= distance*0.2
                var backFrontWidth = r1*2
                if backFrontWidth < miniR1 {
                    backFrontWidth = miniR1
                    backFontView.isHidden = true;
                }else{
                    backFontView.isHidden = false;
                }
                
                backFontView.bounds.size.width = backFrontWidth;
                backFontView.bounds.size.height = backFrontWidth;
                backFontView.layer.cornerRadius = r1
                backFontView.center = CGPoint(x: frontView.bounds.size.width/2, y: frontView.bounds.size.height/2)
                
                //绘制曲线区域
                let o1 = self.convert(backFontView.center, to: overLayView)
                let o2 = frontView.center
                let sin = (o2.x - o1.x)/distance
                let cos = (o2.y - o1.y)/distance
                let pointA = CGPoint(x: o1.x+r1*cos, y: o1.y-r1*sin)
                let pointB = CGPoint(x: o1.x-r1*cos, y: o1.y+r1*sin)
                let pointC = CGPoint(x: o2.x-r2*cos, y: o2.y+r2*sin)
                let pointD = CGPoint(x: o2.x+r2*cos, y: o2.y-r2*sin)
                let controlP1 = CGPoint(x: pointB.x + distance*0.5*sin, y: pointB.y+distance*0.5*cos)
                let controlP2 = CGPoint(x: pointA.x  + distance*0.5*sin, y: pointA.y+distance*0.5*cos)
                
                springPoint = CGPoint(x: originCenter.x + (5)*sin, y: originCenter.y+(5)*cos)
                
                let path = UIBezierPath()
                path.move(to: pointA)
                path.addLine(to: pointB)
                path.addQuadCurve(to: pointC, controlPoint: controlP1)
                path.addLine(to: pointD)
                path.addQuadCurve(to: pointA, controlPoint: controlP2)
                drawRect(path: path)
            }

        }
        
        if sender.state == .failed  || sender.state == .ended || sender.state == .cancelled{
            backFontView.isHidden = true
            curveLayer.removeFromSuperlayer()
            overLayView.removeFromSuperview()
            self.addSubview(frontView)

            if r1 > miniR1{
                frontView.isHidden = false;
                layoutBadgeSubviews()
                disPlaySpringAnimation(startPoint: springPoint)
            }else{
                frontView.isHidden = true;
                showBombAnimation(touchPoint: touchPoint)
                if (finishBolock != nil) {
                    finishBolock!(true);
                }
            }
        }
    }
}
