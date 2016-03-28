//
//  ScreenUtils.swift
//  LastCircleSwift
//
//  Created by Wang Shudao on 12/3/15.
//  Copyright © 2015 MAD. All rights reserved.
//

import UIKit

class ScreenUtils: NSObject {
    
    enum Model: CGFloat {
        case Width320 = 320
        case Width375 = 375
        case Width414 = 414
        case Width768 = 768
        case Width1024 = 1024
        case Other
    }
    
    class func screenWidthModel() -> Model {
        let width =  UIScreen.mainScreen().bounds.width
        switch width {
        case 320:return .Width320
        case 375:return .Width375
        case 414:return .Width414
        case 768:return .Width768
        case 1024:return .Width1024
        default:return .Other
        }
    }
    
    
    class func screenWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    class func screenHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    class func screenShotImage() -> UIImage {
        let window = UIApplication.sharedApplication().keyWindow
        UIGraphicsBeginImageContextWithOptions(window!.frame.size, false, 0.0)
        window?.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return screenShotImage
    }

}
