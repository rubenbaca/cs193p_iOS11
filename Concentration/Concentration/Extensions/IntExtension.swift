//
//  IntExtension.swift
//  Concentration
//
//  Created by Ruben on 12/2/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import Foundation

// Extension for simple but useful uitilities
extension Int {
    
    ///
    /// Get a random number between `self` and 0. If `self` is zero,
    /// zero will be returned.
    ///
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else {
            return 0
        }
        
    }
}
