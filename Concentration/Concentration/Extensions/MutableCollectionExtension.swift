//
//  MutableCollectionExtension.swift
//  Concentration
//
//  Created by Ruben on 12/2/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import Foundation

// Extension for simple but useful uitilities
extension MutableCollection {
    
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        
        // Shuffle logic retrieved from:
        // https://stackoverflow.com/questions/37843647/shuffle-array-swift-3/37843901
        
        // Empty and single-element collections don't shuffle
        if count < 2 { return }
        
        // Shuffle them
        for i in indices.dropLast() {
            let diff = distance(from: i, to: endIndex)
            let j = index(i, offsetBy: numericCast(arc4random_uniform(numericCast(diff))))
            swapAt(i, j)
        }
    }
}
