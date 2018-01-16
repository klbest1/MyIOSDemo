//
//  YQPulaseAnimation.swift
//  Animations
//
//  Created by kang lin on 2018/1/16.
//  Copyright © 2018年 康林. All rights reserved.
//

import UIKit

class YQPulaseAnimation: CALayer {

    var radius:CGFloat = 100;
    var animationDuration:CGFloat = 1
    var group:CAAnimationGroup! ;

    init(radius:CGFloat = 100,animationDurantion:CGFloat = 0.8,tpositon:CGPoint) {
        super.init()
        self.radius = radius;
        self.animationDuration = animationDurantion;
        self.cornerRadius = radius;
        self.position = tpositon;
        self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        self.opacity = 0;
        self.backgroundColor = UIColor.blue.cgColor;
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
           self.setupAnimationGroup()
            DispatchQueue.main.async {
                self.add(self.group, forKey: "pulse")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createScaleAnimate() ->CABasicAnimation {
        let animate = CABasicAnimation(keyPath: "transform.scale.xy")
        animate.duration = CFTimeInterval(animationDuration)
        animate.fromValue = 0.6;
        animate.toValue = 1.0
        return animate;
    }
    
    func createAlpaAnimate() ->CAKeyframeAnimation {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "opacity");
        keyFrameAnimation.values = [0.4,0.8,0]
        keyFrameAnimation.keyTimes = [0,0.2,1]
        return keyFrameAnimation;
    }
    
    func setupAnimationGroup() {
         group = CAAnimationGroup()
        group.animations = [createScaleAnimate(),createAlpaAnimate()];
        group.repeatCount = 0
        group.duration = CFTimeInterval(animationDuration);
        
    }
}
