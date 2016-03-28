//
//  CountDownView.swift
//  LastCircleSwift
//
//  Created by Wang Shudao on 9/23/15.
//  Copyright © 2015 MAD. All rights reserved.
//

import UIKit

class CountDownView: UIView {

    var progressView: UIView = UIView(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.progressView.frame = CGRectMake(0, 0, 0, frame.size.height)
        self.progressView.backgroundColor = UIColor.greenColor()
        self.addSubview(self.progressView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateProgress(time:CGFloat, total:CGFloat) {
        let progressViewWidth = frame.size.width * time / total
        progressView.frame = CGRectMake(0, 0, progressViewWidth, frame.size.height)

        let r,g,b :CGFloat
        let a: CGFloat = 1.0
        if time < total/2 {
            r = time/total*2
            g = 1
        } else {
            r = 1
            g = 2 - time/total*2
        }
        b = 0
        let currentColor = UIColor(red: r, green: g, blue: b, alpha: a)
        progressView.backgroundColor = currentColor
    }

}