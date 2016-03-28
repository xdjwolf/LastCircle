//
//  CircleViewController.swift
//  LastCircleSwift
//
//  Created by Wang Shudao on 9/10/15.
//  Copyright © 2015 MAD. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController {
    
    var lastCircleView:CircleView!
    var touched = true
    var isTestMode = false
    var timer: NSTimer?
    var updateProgressTimer: NSTimer?
    var startTime: NSDate?
    let updateOperation = NSBlockOperation()
    let queue = NSOperationQueue()
    let screenWidth = UIScreen.mainScreen().bounds.width
    let minTime: CGFloat = 1
    let bonusTime: CGFloat = 0.5
    let tolerance: CGFloat = 10
    var totalTime: CGFloat = 0
    var countDownView: CountDownView = CountDownView(frame: CGRectZero)
    var circleViews = [CircleView]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalTime = minTime + bonusTime * CGFloat(CircleFactory.sharedCircleFactory.circles.count)
        
        for circle in CircleFactory.sharedCircleFactory.circles {
            let color = ColorUtils.randomColor()
            circle.color = color
            let cv = CircleView(circle: circle)
            if circle === CircleFactory.sharedCircleFactory.circles.last! {
                self.lastCircleView = cv
            }
            if GameUtils.sharedUtils.mode == .BlackWhite {
                cv.alpha = 1
            } else {
                cv.alpha = 0
            }
            self.view.addSubview(cv)
            circleViews.append(cv)
            
            // set count down progress bar height
            switch ScreenUtils.screenWidthModel() {
            case .Width320, .Width375, .Width414, .Other:
                countDownView = CountDownView(frame: CGRectMake(0, 0, screenWidth, 5))
            case .Width768:
                countDownView = CountDownView(frame: CGRectMake(0, 0, screenWidth, 10))
            case .Width1024:
                countDownView = CountDownView(frame: CGRectMake(0, 0, screenWidth, 15))
            }
            self.view.addSubview(countDownView)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // animations
        
        if GameUtils.sharedUtils.mode == .Colorful {
            for cv in circleViews {
                let delay = Double(arc4random()) / Double(UINT32_MAX) * 0.3
                cv.transform = CGAffineTransformMakeScale(0.1, 0.1)
                UIView.animateWithDuration(0.5,
                    delay: delay,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 6.0,
                    options: UIViewAnimationOptions.AllowUserInteraction,
                    animations: {
                        cv.alpha = 1
                        cv.transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
        }
        
        if !isTestMode {
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "goToGameOver", userInfo: nil, repeats: false)
        }
        
        // update progress delay 0.8 second
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            
            self.startTime = NSDate()
            weak var weakOperaion = self.updateOperation
            self.updateOperation.addExecutionBlock { () -> Void in
                while weakOperaion?.cancelled == false {
                    NSThread.sleepForTimeInterval(1/60)
                    let interval = NSDate().timeIntervalSinceDate(self.startTime!)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.countDownView.updateProgress(CGFloat(interval), total: self.totalTime)
                    })
                }
            }
            self.queue.addOperation(self.updateOperation)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Touch
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let elapsedTimeInterval: NSTimeInterval
        if let startTime = self.startTime {
            elapsedTimeInterval = NSDate().timeIntervalSinceDate(startTime)
        } else {
            elapsedTimeInterval = 0
        }
        
        if isTestMode {
            goToNextRound()
        } else {
            timer!.invalidate()
            updateOperation.cancel()
            queue.cancelAllOperations()
            self.countDownView.removeFromSuperview()
            if touched {
                let touch = touches.first!
                let point = touch.locationInView(self.view)
                let sizeSide = CGFloat(CircleFactory.sharedCircleFactory.circles.last!.radius) + tolerance
                var roundedRect = lastCircleView.frame
                roundedRect.origin.x -= tolerance
                roundedRect.origin.y -= tolerance
                roundedRect.size.width += 2*tolerance
                roundedRect.size.height += 2*tolerance
                
                let maskPath = UIBezierPath(roundedRect: roundedRect,
                    byRoundingCorners: UIRectCorner.AllCorners,
                    cornerRadii: CGSizeMake(sizeSide, sizeSide))
                if maskPath.containsPoint(point) {
                    let score = Int((self.totalTime - CGFloat(elapsedTimeInterval))*10)
                    ScoreManager.sharedManager.currentScore += score
                    goToNextRound()
                } else {
                    lastCircleView.blink(goToGameOver);
                }
                touched = false
            }
        }
    }
    
    // MARK: Private methods
    
    func goToGameOver() {
        updateOperation.cancel()
        queue.cancelAllOperations()
        
        let screentShotImage = ScreenUtils.screenShotImage()
        let gameOverVC = GameOverViewController()
        gameOverVC.screenShotImage = screentShotImage
        self.navigationController?.pushViewController(gameOverVC, animated: true)
    }
    
    func goToNextRound() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.lastCircleView.transform = CGAffineTransformScale(self.view.transform, 30, 30)
            }) { (_) -> Void in
                CircleFactory.sharedCircleFactory.addCircle()
                let rvc = RoundViewController()
                rvc.round = CircleFactory.sharedCircleFactory.circles.count
                rvc.view.backgroundColor = self.lastCircleView.backgroundColor
                self.navigationController?.pushViewController(rvc, animated: false)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private func changeBackgroundColor(color: UIColor!) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.backgroundColor = color
            }) { (_) -> Void in
                self.goToNextRound()
        }
        
    }
}
