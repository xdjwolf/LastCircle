//
//  GameOverViewController.swift
//  LastCircleSwift
//
//  Created by Wang Shudao on 9/16/15.
//  Copyright © 2015 MAD. All rights reserved.
//

import UIKit
import CloudKit

class GameOverViewController: UIViewController {
    
    // MARK: Properties
    let gap: CGFloat = 15
    let sideMargin: CGFloat = 15
    let kRestartButtonCornerRadius: CGFloat = 50
    
    var labels = [UILabel]()
    var isButtonAnimating = false
    var screenShotImage: UIImage?
    
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var scaleView: UIView!
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopAnimating:", name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restartButtonAnimation:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        // display the score
        let bestScore = ScoreManager.sharedManager.best
        let currentScore = ScoreManager.sharedManager.currentScore
        
        switch ScreenUtils.screenWidthModel() {
        case .Width320, .Width375, .Width414, .Other:
            finalScoreLabel.font = UIFont(name: "Futura", size: 20)
        case .Width768:
            finalScoreLabel.font = UIFont(name: "Futura", size: 30)
        case .Width1024:
            finalScoreLabel.font = UIFont(name: "Futura", size: 50)
        }
        
        
        if (currentScore < bestScore) {
            finalScoreLabel.text = "Score: \(currentScore)   Best: \(bestScore)"
        } else {

            
            finalScoreLabel.text = "New Best: \(currentScore)"
            ScoreManager.sharedManager.best = currentScore
        }
        
        
        
        restartButton.layer.cornerRadius = kRestartButtonCornerRadius
        scaleView.layer.cornerRadius = kRestartButtonCornerRadius
        
        // set colors
        switch GameUtils.sharedUtils.mode {
        case .BlackWhite:
            restartButton.backgroundColor = UIColor.blackColor()
            scaleView.backgroundColor = UIColor.blackColor()
            finalScoreLabel.alpha = 1
            for label in labels {
                label.alpha = 1
            }
        case .Colorful:
            let buttonColor = ColorUtils.randomColor()
            restartButton.backgroundColor = buttonColor
            scaleView.backgroundColor = buttonColor
            finalScoreLabel.alpha = 0
        }
        
        self.view.layoutIfNeeded()
        
        // set title view
        let gameOverLabelsView = titleView()
        self.view.addSubview(gameOverLabelsView)
        gameOverLabelsView.center = CGPoint(x: ScreenUtils.screenWidth()/2, y: ScreenUtils.screenHeight()/4)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // handle 4s
        if (ScreenUtils.screenHeight() == 480) {
            restartButton.y -= 40
            scaleView.y -= 40
            view.setNeedsLayout()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if GameUtils.sharedUtils.mode == .Colorful {
            
            // show game over title
            for label in labels {
                label.transform = CGAffineTransformMakeScale(0.5, 0.5)
                
                let delay = Double(arc4random()) / Double(UINT32_MAX) * 0.3
                let duration = Double(arc4random()) / Double(UINT32_MAX) * 1
                UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseOut,
                    animations: { () -> Void in
                        label.transform = CGAffineTransformMakeScale(1, 1)
                        label.alpha = 1
                    }, completion: nil)
            }
            
            // show score
            UIView.animateWithDuration(0.3) { () -> Void in
                self.finalScoreLabel.alpha = 1
            }
        }
        
        // animate restart button
        startButtonAnimation()
        isButtonAnimating = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func restartTapped(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mvc = storyboard.instantiateViewControllerWithIdentifier("MainViewController")
        navigationController?.pushViewController(mvc, animated: true)
    }
    
    private func startButtonAnimation() {
        UIView.animateWithDuration(1, delay: 0, options: [.CurveEaseInOut, .Repeat, .Autoreverse, .AllowUserInteraction],
            animations: { () -> Void in
                self.scaleView.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func titleView() -> UIView {
        let titleView = UIView()
        let screenWidth = ScreenUtils.screenWidth()
        let labelWidth = (screenWidth - 2*sideMargin - 3*gap)/4
        
        // UILabels
        for index in 0..<8 {
            let label = UILabel()
            label.size = CGSize(width: labelWidth, height: labelWidth)
            label.layer.cornerRadius = labelWidth/2
            label.layer.masksToBounds = true
            switch GameUtils.sharedUtils.mode {
            case .BlackWhite:
                label.backgroundColor = UIColor.blackColor()
            case .Colorful:
                label.backgroundColor = ColorUtils.randomColor()
            }
            label.textAlignment = .Center
            label.tag = 1000 + index
            label.textColor = UIColor.whiteColor()
            label.font = UIFont(name: "Futura", size: labelWidth-12)
            label.alpha = 0
            titleView.addSubview(label)
            labels.append(label)
        }
        titleView.size = CGSize(width: screenWidth - 2*sideMargin, height: labelWidth*2 + gap)
        
        labels[0].text = "G"
        labels[1].text = "A"
        labels[2].text = "M"
        labels[3].text = "E"
        
        labels[4].text = "O"
        labels[5].text = "V"
        labels[6].text = "E"
        labels[7].text = "R"
        
        // Positioning
        for index in 0...7 {
            let label = labels[index]
            label.x = CGFloat(index%4)*(gap + labelWidth)
            label.y = index < 4 ? 0 : gap + labelWidth
        }
        
        return titleView
    }
    
    // Mark - Notification
    
    @objc func restartButtonAnimation(notification: NSNotification) {
        if !isButtonAnimating {
            startButtonAnimation()
        }
    }
    
    @objc func stopAnimating(notification: NSNotification) {
        isButtonAnimating = false
        scaleView.layer.removeAllAnimations()
        scaleView.transform = CGAffineTransformIdentity
    }
}
