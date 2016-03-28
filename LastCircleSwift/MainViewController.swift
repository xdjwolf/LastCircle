//
//  ViewController.swift
//  LastCircleSwift
//
//  Created by Wang Shudao on 9/1/15.
//  Copyright © 2015 MAD. All rights reserved.
//

import UIKit
import QuartzCore

class MainViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var randomColorButton: UIButton!
    @IBOutlet weak var scaleView: UIView!
    
    var circleViews = [CircleView]()
    var isButtonAnimating = false
    var isBackgroundAnimating = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopAnimating:", name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restartButtonAnimation:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restartBackgroundCircleAnimation:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScoreManager.sharedManager.currentScore = 0
        
        switch GameUtils.sharedUtils.mode {
        case .BlackWhite:
            self.view.backgroundColor = UIColor.blackColor()
        case .Colorful:
            self.view.backgroundColor = UIColor.whiteColor()
        }
        
        let color = ColorUtils.randomColor(1)
        self.randomColorButton.layer.cornerRadius = 75
        self.randomColorButton.backgroundColor = color
        self.scaleView.layer.cornerRadius = 75
        self.scaleView.backgroundColor = color
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        startButtonAnimation()
        for _ in 0...7 {
            startBackgroundCircleAnimation()
        }
        
        isButtonAnimating = true
        isBackgroundAnimating = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowRound" {
            if let roundViewController = segue.destinationViewController as? RoundViewController {
                roundViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl;
            }
        }
    }
    
    @IBAction func startGame(sender: UIButton) {
        ScoreManager.sharedManager.currentScore = 0
        self.randomColorButton .setTitle("", forState: .Normal)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.randomColorButton.transform = CGAffineTransformScale(self.randomColorButton.transform, 20, 20)
            }) { (_) -> Void in
                
                CircleFactory.sharedCircleFactory.circles.removeAll()
                CircleFactory.sharedCircleFactory.addCircle()
                let rvc = RoundViewController()
                rvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                rvc.round = 1
                rvc.view.backgroundColor = self.randomColorButton.backgroundColor
                self.navigationController?.pushViewController(rvc, animated: false)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Mark - Notification
    @objc func stopAnimating(notification: NSNotification) {
        isButtonAnimating = false
        isBackgroundAnimating = false
        scaleView.layer.removeAllAnimations()
        scaleView.transform = CGAffineTransformIdentity
        for cv in circleViews {
            cv.removeFromSuperview()
        }
    }
    
    @objc func restartButtonAnimation(notification: NSNotification) {
        if !isButtonAnimating {
            startButtonAnimation()
        }
    }
    
    @objc func restartBackgroundCircleAnimation(notification: NSNotification) {
        if !isBackgroundAnimating {
            for _ in 0...7 {
                startBackgroundCircleAnimation()
            }
        }
    }
    
    // Mark - Aniamtions
    private func startButtonAnimation() {
        UIView.animateWithDuration(1, delay: 0, options: [.CurveEaseInOut, .Repeat, .Autoreverse],
            animations: { () -> Void in
                self.scaleView.transform = CGAffineTransformMakeScale(1.5, 1.5)
            }, completion:nil)
    }
    
    private func startBackgroundCircleAnimation() {
        let circle = Circle.randomCircle()
        let color = ColorUtils.randomColor()
        circle.color = color
        let cv = CircleView(circle: circle)
        cv.userInteractionEnabled = false
        self.view.insertSubview(cv, belowSubview: self.scaleView)
        circleViews.append(cv)
        
        
        let delay = Double(arc4random()) / Double(UINT32_MAX) * 1
        let duration = Double(arc4random()) / Double(UINT32_MAX) * 4 + 0.5
        
        cv.alpha = 0
        cv.transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        weak var weakSelf = self
        UIView.animateWithDuration(duration,
            delay: delay,
            options : [.CurveLinear],
            animations: { () -> Void in
                cv.alpha = 0.4
                cv.transform = CGAffineTransformMakeScale(1, 1)
            }) { (finished) -> Void in
                if !finished {
                    return
                } else {
                    UIView.animateWithDuration(duration,
                        delay: 0,
                        options: [.CurveLinear],
                        animations: { () -> Void in
                            cv.alpha = 0
                            cv.transform = CGAffineTransformMakeScale(2, 2)
                        }, completion: { (finished) -> Void in
                            cv.removeFromSuperview()
                            if !finished {
                                return
                            } else {
                                weakSelf!.startBackgroundCircleAnimation()
                            }
                    })
                }
        }
    }
}

