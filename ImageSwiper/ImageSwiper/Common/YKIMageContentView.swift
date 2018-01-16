//
//  YKIMageContentView.swift
//  ImageSwiper
//
//  Created by kang lin on 2018/1/3.
//  Copyright © 2018年 Jack. All rights reserved.
//

import UIKit

protocol ImageScrollerDelegate:class{
    func numerOfCells() -> Int;
    func cellForRowAtIndex(index:NSInteger,imageContentView:YKIMageContentView) -> YKImageViewCell;
    func didSelectedCellAtIndex(index:NSInteger,cell:YKImageViewCell);
    func didSwipToLeft(index:NSInteger);
    func didSwipToRight(index:NSInteger)
}

class YKIMageContentView: UIView {

    weak var delegate:ImageScrollerDelegate?
    var numberOfInitImages = 3;
    
    public private(set) var  visisbleCells:[YKImageViewCell] = [YKImageViewCell]()
    fileprivate var numberOfItems = 0;
    fileprivate var imageView:YKImageViewCell?  {
        return self.visisbleCells.first;
    }

    fileprivate var reuseCells:[YKImageViewCell] = [YKImageViewCell]()
    
    fileprivate struct ImageTouchePart:OptionSet{
        public let rawValue: Int
        
        public init(rawValue:Int){
            self.rawValue = rawValue;
        }
        
        static let none =  ImageTouchePart(rawValue: 1<<0)
        static let touchLeft = ImageTouchePart(rawValue: 1<<1)
        static let touchRight = ImageTouchePart(rawValue: 1<<2)
    }
    
    fileprivate var activeTouchPart:ImageTouchePart = .none {
        didSet{
        }
    }
    
    fileprivate var touchImageCenter:CGPoint!
    fileprivate var rotatedAngel:CGFloat = 0.0
    
    fileprivate var touchLeftFrame:CGRect{
        return CGRect(x: 0, y: 0, width: self.bounds.size.width/2, height: self.bounds.size.height)
    }
    
    fileprivate var touchOrignFrame:CGRect{
        return CGRect(x: self.bounds.size.width/2-50, y: self.bounds.size.height/2-50, width: 100, height: 100)
    }
    
    fileprivate var touchRightFrame:CGRect{
        return CGRect(x: self.bounds.size.width/2, y: 0, width: self.bounds.size.width/2, height: self.bounds.size.height)
    }
    
    fileprivate var screenBottomCenter:CGPoint{
        return CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height)
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white;
        
        let panGuesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGuesture);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect{
        didSet{
            constructingViews()
        }
    }
    
    fileprivate func emptyViews(){
        let views = self.subviews
        for view in views{
            view.removeFromSuperview()
        }
         
    }
    
    fileprivate func constructingViews()  {
        emptyViews()
        numberOfItems = self.delegate?.numerOfCells() ?? 0
        var initNumberOfImages = 3;
        if initNumberOfImages > numberOfItems{
            initNumberOfImages = numberOfItems
        }
        for i in 0..<initNumberOfImages{
            var cell  = self.delegate?.cellForRowAtIndex(index: i,imageContentView: self)
            setCellShowProperties(cell: &cell!, index: i%initNumberOfImages)
            visisbleCells.append(cell!);
            cell?.tag = i;
            cell?.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
            self.insertSubview(cell!, at: 0);
        }
    }
    
    fileprivate func setCellShowProperties(cell:inout YKImageViewCell,index:NSInteger){
        let scaleY = CGFloat(1.0-0.07*Double(index))
        let transfrom  = CGAffineTransform(scaleX: CGFloat(1.0-0.07*Double(index)), y: scaleY)
        let cellHeight = cell.bounds.size.height
        let moveY = 4.0 * CGFloat(index) + (cellHeight - (cellHeight * scaleY))
        cell.transform = CGAffineTransform(translationX: 0, y: CGFloat(moveY)).concatenating(transfrom)
        cell.initTransform = (cell.transform);
    }
    
    override func layoutSubviews() {
    }
    
    fileprivate func getTouchArea(point:CGPoint) -> ImageTouchePart {
        if touchLeftFrame.contains(point) {
            return .touchLeft
        }
        if touchRightFrame.contains(point) {
            return .touchRight
        }
        
        return .none;
    }
    
    //MARK: - public functions
    func reloadView()  {
        constructingViews()
    }
    
    func dqueueReuseCell() -> YKImageViewCell? {
        if let resueCell = reuseCells.first{
            reuseCells.removeFirst()
            return resueCell
        }
        return nil
    }
    
    //MARK: - Touch  事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        touchImageCenter = visisbleCells.first?.center;
    }
    
    func checkAngle(firstPoint:CGPoint , lastPoint:CGPoint) -> Double{
        let yDistance = Double(lastPoint.y - firstPoint.y)
        let xDistance = Double(lastPoint.x - firstPoint.x)
        let angle = atan2(abs(yDistance), abs(xDistance))
//        print("angle:\(angle/M_PI * 180)")
        return angle
    }
    
    func getScale(from transform: CGAffineTransform) -> CGFloat {
        return sqrt(CGFloat(transform.a * transform.a + transform.c * transform.c))
    }
    
    func scaleCells(translation:CGPoint)  {
        for i in 1..<visisbleCells.count{
            let cell = visisbleCells[i]
            var scaleX = getScale(from: cell.initTransform)
            var transY =  cell.initTransform.ty
            scaleX += abs(translation.x)*0.02/CGFloat(i)*(1.0-scaleX);
            if scaleX > getScale(from: cell.transform) && getScale(from: visisbleCells[1].transform) == 1.0{
                break;
            }
//            transY -= abs(translation.y)*0.02/CGFloat(i)*(1.0-scaleX);
//            print("transY:\(transY)")
            if scaleX >= 1.0{
                scaleX = 1.0
            }
            if transY <= 0{
                transY = 0
            }
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX).concatenating(CGAffineTransform(translationX: 0, y: transY))
            })
        }
    }
    
    @objc func handlePan(_ sender:UIPanGestureRecognizer)  {
        if sender.state == .began {
            touchImageCenter = visisbleCells.first?.center;
        }
        
        if sender.state == .changed {
            let translationPoint = sender.translation(in: self)
//            print("translationPoint:\(translationPoint)");
//            let velocity = sender.velocity(in: self);
//            print("velocity:\(velocity)");
            var moveingCenter = touchImageCenter!
            moveingCenter.x += translationPoint.x;
            moveingCenter.y += translationPoint.y;
            imageView?.center = moveingCenter;
            
            let point = sender.location(in: self)
            activeTouchPart = getTouchArea(point: point)
            if activeTouchPart.contains(.touchLeft) {
                let angle =  checkAngle(firstPoint: screenBottomCenter, lastPoint: point)
                rotatedAngel = CGFloat(angle);
//                print("angle:\(angle/Double.pi * 180)")
                UIView.animate(withDuration: 0.3, animations: {
                    self.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(-(Double.pi/2 - angle)))
                })
            }
            
            if activeTouchPart.contains(.touchRight) {
                let angle =  checkAngle(firstPoint: screenBottomCenter, lastPoint: point)
                rotatedAngel = CGFloat(angle);
                UIView.animate(withDuration: 0.3, animations: {
                    self.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2 - angle))
                })
            }
            //放大下层的View
            scaleCells(translation: translationPoint)
            
            //移动时添加最后一张图
            if self.visisbleCells.count == numberOfInitImages
                && numberOfItems > numberOfInitImages
                && visisbleCells.last!.tag + 1 < numberOfItems{
                var cell =  self.delegate?.cellForRowAtIndex(index: visisbleCells.last!.tag + 1,imageContentView: self)
                setCellShowProperties(cell: &cell!, index: 3)
                cell?.tag = visisbleCells.last!.tag + 1;
                visisbleCells.append(cell!);
                self.insertSubview(cell!, at: 0);
                cell?.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
            }
        }
        
        if sender.state == .ended {
            let point = sender.location(in: self)
            let velocity = sender.velocity(in: self);
//            print("velocity:\(velocity)");
            //移动到了中间，回归原样，回归原样，或者只剩1张时
            if abs(velocity.x) < 50 || visisbleCells.count == 1 {
                if self.visisbleCells.count > numberOfInitImages{
                    //删除最后一个
                    visisbleCells.last?.removeFromSuperview()
                    reuseCells.append( visisbleCells.last!)
                    visisbleCells.removeLast();
                }
                rearrangeCells()
                return;
            }
            activeTouchPart = getTouchArea(point: point)
            
            if activeTouchPart.contains(.touchLeft) {
                self.delegate?.didSwipToRight(index: 0)
            }
            
            if activeTouchPart.contains(.touchRight) {
                self.delegate?.didSwipToRight(index: 0)
            }
            //删除第一个
            reuseCells.append(imageView!)
            imageView?.removeFromSuperview()
            visisbleCells.removeFirst();
            activeTouchPart = .none
            
            //重排后面的cell大小和位置
            rearrangeCells()
        }
    }
    
    fileprivate func rearrangeCells(){
        for i in 0..<visisbleCells.count{
            var cell  = visisbleCells[i]
            UIView.animate(withDuration : 0.5, delay: 0, usingSpringWithDamping : 0.6, initialSpringVelocity : 0.6, options: .curveEaseInOut, animations: {
                  [weak self] in
                self?.setCellShowProperties(cell: &cell, index: i)
                cell.center = CGPoint(x: self!.bounds.size.width/2, y: self!.bounds.size.height/2)
            }, completion: {
              (finish)  in
            })

        }
    }
    
    //MARK: - 点击事件
    @objc func cellClick(_ sender:YKImageViewCell)  {
        self.delegate?.didSelectedCellAtIndex(index: sender.tag, cell: sender)
    }
}
