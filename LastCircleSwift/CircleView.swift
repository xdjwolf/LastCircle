//
//  CircleView.swift
//  FoodTracker
//
//  Created by Wang Shudao on 9/9/15.
//  Copyright © 2015 MAD. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(circle: Circle) {
        let frame = CGRectMake(0, 0, CGFloat(circle.radius*2), CGFloat(circle.radius*2))
        super.init(frame: frame)
        self.backgroundColor = circle.color
        self.center = circle.center
        self.layer.cornerRadius = CGFloat(circle.radius)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func blink(completion: ()-> Void) {
        let scaleUpAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleUpAnim.toValue = NSNumber(float: 1.5)
        scaleUpAnim.repeatCount = 3
        scaleUpAnim.duration = 0.2
        scaleUpAnim.autoreverses = true
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.layer.addAnimation(scaleUpAnim, forKey: nil);
        CATransaction.commit()
    }
}
