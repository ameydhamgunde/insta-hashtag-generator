//
//  pulsing.swift
//
//  Created by Amey Dhamgunde on 2019-03-20.
//  Copyright © 2019 Amey Dhamgunde. All rights reserved.
//
//  This class creates an pulse animation with CoreAnimation, used in various places in the app.
//

import UIKit

public class pulseAnimation : CALayer {
    
    public var animationGroup = CAAnimationGroup()
    
    public var initialPulseScale:Float = 0
    public var nextPulseAfter:TimeInterval = 0
    public var animationDuration:TimeInterval = 1.5
    public var radius:CGFloat = 200
    public var numberOfPulses:Float = Float.infinity
    
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    public init (numberOfPulses:Float = Float.infinity, radius:CGFloat, position:CGPoint, duration:TimeInterval) {
        super.init()
        
        self.backgroundColor = UIColor.purple.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.numberOfPulses = numberOfPulses
        self.position = position
        
        self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        self.cornerRadius = radius
        self.animationDuration = duration
        
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.setupAnimationGroup()
            
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "pulse")
            }
        }
    }
    
    
    public func createScaleAnimation () -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: initialPulseScale)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        
        return scaleAnimation
    }
    
    public func createOpacityAnimation() -> CAKeyframeAnimation {
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [0.4, 0.8, 0]
        opacityAnimation.keyTimes = [0, 0.2, 1]
        
        return opacityAnimation
    }
    
    public func setupAnimationGroup() {
        self.animationGroup = CAAnimationGroup()
        self.animationGroup.duration = animationDuration + nextPulseAfter
        self.animationGroup.repeatCount = numberOfPulses
        
        let defaultCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        self.animationGroup.timingFunction = defaultCurve
        
        self.animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
    }
}
