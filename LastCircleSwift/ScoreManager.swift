//
//  ScoreManager.swift
//  LastCircleSwift
//
//  Created by Wang Shudao on 12/3/15.
//  Copyright © 2015 MAD. All rights reserved.
//

import Foundation

class ScoreManager {
    
    static let sharedManager = ScoreManager()
    let kUserDefaultBestScoreKey = "Best score"
    
    var best: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey(kUserDefaultBestScoreKey)
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: kUserDefaultBestScoreKey)
        }
    }
    
    var currentScore = 0
    
}