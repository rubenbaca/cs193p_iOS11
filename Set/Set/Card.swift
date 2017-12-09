//
//  Card.swift
//  Set
//
//  Created by Ruben on 12/7/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import Foundation

///
/// Represents a Card used in the `SetGame`
///
struct Card {

    ///
    /// There are 4 different features a card might have. Each feature's value might vary based
    /// on the `Variant` options.
    ///
    /// These features and variants are completely generic and not tied to any specific ones. For
    /// instance, a "classic" game would contain:
    ///    - Feature1: color
    ///    - Feature2: shape
    ///    - Feature3: shade
    ///    - Feature4: number
    ///
    init(_ feature1: Variant, _ feature2: Variant, _ feature3: Variant, _ feature4: Variant) {
        self.feature1 = feature1
        self.feature2 = feature2
        self.feature3 = feature3
        self.feature4 = feature4
    }

    // Assignment 2 (Task #13): "13.Use an enum as a meaningful part of your solution."
    
    ///
    /// Each feature might contain one of three different variants.
    ///
    /// These variants are completely generic and not tied to any specific ones.
    ///
    enum Variant: Int {
        case v1 = 1
        case v2 = 2
        case v3 = 3
    }

    let feature1: Variant
    let feature2: Variant
    let feature3: Variant
    let feature4: Variant
}

// Conform to `CustomStringConvertible`
extension Card: CustomStringConvertible {
    var description: String {
        return "[\(feature1.rawValue), \(feature2.rawValue), \(feature3.rawValue), \(feature4.rawValue)]"
    }
}

// Conform to `Equatable`
extension Card: Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return (
            (lhs.feature1 == rhs.feature1) &&
            (lhs.feature2 == rhs.feature2) &&
            (lhs.feature3 == rhs.feature3) &&
            (lhs.feature4 == rhs.feature4)
        )
    }
}

// Conform to `Hashable`
extension Card: Hashable {
    var hashValue: Int {
        return feature1.rawValue ^ feature2.rawValue ^ feature3.rawValue ^ feature4.rawValue
    }
}
