//
//  CGFloatExtension.swift
//  PlayingCard
//
//  Created by Ruben on 12/16/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import UIKit

// Extension for simple but useful uitilities
extension CGFloat {
    var arc4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
}
