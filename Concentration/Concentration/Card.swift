//
//  Card.swift
//  Concentration
//
//  Created by Ruben on 11/30/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import Foundation

///
/// Represents a "Card" that is used in the "Concentration" game
///
struct Card {
    
    ///
    /// Is the current card facing up?
    ///
    var isFaceUp = false
    
    ///
    /// Is the current card already matched?
    ///
    /// A matched card means that the user playing the game already
    /// found both "matching" cards.
    ///
    var isMatched = false
    
    ///
    /// A unique identifier for the card.
    /// (The pair of matching cards have the same identifier)
    ///
    var identifier: Int
    
    ///
    /// Create a card with the given identifier
    ///
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
    ///
    /// Static identifier that is increased every time a new one is
    /// requested by getUniqueIdentifier()
    ///
    static var identifierFactory = 0
    
    ///
    /// Returns a unique id to be used as a card identifier
    ///
    static func getUniqueIdentifier() -> Int {
        Card.identifierFactory += 1
        return Card.identifierFactory
    }
}
