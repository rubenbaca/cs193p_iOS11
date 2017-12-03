//
//  CollectionExtension.swift
//  Concentration
//
//  Created by Ruben on 12/2/17.
//  Copyright © 2017 Ruben. All rights reserved.
//

// Extension for simple but useful uitilities
extension Collection {
    ///
    /// If the collection contains only one element, return it. Otherwise,
    /// return nil.
    ///
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
