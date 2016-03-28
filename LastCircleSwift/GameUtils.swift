//
//  GameUtils.swift
//  LastCircleSwift
//
//  Created by Wang Shudao on 12/4/15.
//  Copyright © 2015 MAD. All rights reserved.
//

import Foundation

class GameUtils {
    enum Mode {
        case BlackWhite
        case Colorful
    }
    
    static let sharedUtils = GameUtils()
    var mode: Mode {
        return .Colorful
    }
}
