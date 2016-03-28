//
//  RoundViewController.swift
//  LastCircleSwift
//
//  Created by Wang Shudao on 9/6/15.
//  Copyright © 2015 MAD. All rights reserved.
//

import UIKit

class RoundViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var roundTitleLabel: UILabel!
    var round: Int!
    let cvc = CircleViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // set colors
        switch GameUtils.sharedUtils.mode {
        case .BlackWhite:
            self.roundLabel.textColor = UIColor.blackColor()
            self.roundTitleLabel.textColor = UIColor.blackColor()
            cvc.view.backgroundColor = UIColor.blackColor()
        case .Colorful:
            self.roundLabel.textColor = UIColor.whiteColor()
            self.roundTitleLabel.textColor = UIColor.whiteColor()
            cvc.view.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        }
        
        switch ScreenUtils.screenWidthModel() {
        case .Width320, .Width375, .Width414, .Other:
            roundLabel.font = UIFont(name: "Futura", size: 50)
            roundTitleLabel.font = UIFont(name: "Futura", size: 50)
        case .Width768:
            roundLabel.font = UIFont(name: "Futura", size: 80)
            roundTitleLabel.font = UIFont(name: "Futura", size: 80)
        case .Width1024:
            roundLabel.font = UIFont(name: "Futura", size: 120)
            roundTitleLabel.font = UIFont(name: "Futura", size: 120)
        }
        
        self.roundLabel.text = "\(self.round)"
        self.roundLabel.alpha = 0
        self.roundTitleLabel.alpha = 0
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.8 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.goToCircleViewController()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animateWithDuration(0.2) { () -> Void in
            self.roundLabel.alpha = 1
            self.roundTitleLabel.alpha = 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    func goToCircleViewController() {
        navigationController?.pushViewController(cvc, animated: false)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
