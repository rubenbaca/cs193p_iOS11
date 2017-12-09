//
//  SetGame.swift
//  Set
//
//  Created by Ruben on 12/7/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import Foundation

///
/// Provides the core functionality of a set game (Model)
///
/// Rules
/// The object of the game is to identify a 'set' of three cards from 12 cards laid out on the
/// table. Each card has a variation of the following four features:
///
/// (A) Color:
/// Each card is red, green, or purple.
///
/// (B) Symbol:
/// Each card contains ovals, squiggles, or diamonds.
///
/// (C) Number:
/// Each card has one, two, or three symbols.
///
/// (D) Shading: Each card is solid, open, or striped.
///
/// A 'Set' consists of three cards in which each feature is EITHER the same on each card OR is
/// different on each card. That is to say, any feature in the 'Set' of three cards is either
/// common to all three cards or is different on each card.
///
struct SetGame {

    ///
    /// Keeps track of the current score
    ///
    private(set) var score = 0 // Assignment 2 (Task #16): "Keep a score"
    
    ///
    /// Create a new set game with no initial cards. Call `draw(n:)` to open the first 'n'
    /// number of cards.
    ///
    init() {
        // Populate the deck of cards
        populateDeck()
    }
    
    ///
    /// The deck of available cards. Starts with all cards in it.
    ///
    /// Drawing cards (`draw()`/`draw(n:)`) will move them from `deck` -> `openCards`
    ///
    private(set) var deck = Set<Card>()
    
    ///
    /// The list of open/available/facing-up cards. From these cards, the caller might
    /// evaluate whether or not three cards are a set (`evaluate(_)`).
    ///
    private(set) var openCards = Set<Card>()

    ///
    /// Populate the deck of cards.
    ///
    private mutating func populateDeck() {
        for feature1 in 1...3 {
            for feature2 in 1...3 {
                for feature3 in 1...3 {
                    for feature4 in 1...3 {
                        deck.insert(
                            Card(
                                Card.Variant(rawValue: feature1)!,
                                Card.Variant(rawValue: feature2)!,
                                Card.Variant(rawValue: feature3)!,
                                Card.Variant(rawValue: feature4)!
                            )
                        )
                    }
                }
            }
        }
    }
    
    ///
    /// Draw `n` number of random cards from the `deck`, and place them into the `openCards` list.
    ///
    /// Returns the cards that were opened.
    ///
    @discardableResult
    mutating func draw(n: Int) -> Set<Card> {

        // List of opened cards
        var newCards = Set<Card>()
        
        for _ in 1...n {
            if let newCard = deck.removeRandomElement() {
                newCards.insert(newCard)
            }
            else {
                break // no more cards in the deck
            }
        }
        // The new cards will be added to the openCards list (and also returned to the caller)
        for card in newCards {
            openCards.insert(card)
        }
        return newCards
    }
    
    ///
    /// Draw one random card from the `deck`, and place it into the `openCards` list.
    ///
    /// Returns the card that was opened. (nil if none available)
    ///
    @discardableResult
    mutating func draw() -> Card? {
        if let newCard = deck.removeRandomElement() {
            openCards.insert(newCard)
            return newCard
        }
        return nil
    }
    
    ///
    /// Evaluate the given cards. Return whether or not they are a valid set.
    ///
    /// - Given cards must exist in the `openCards` list.
    /// - If cards are a valid match/set, they will be removed from the `openCards` list.
    ///
    mutating func evaluateSet(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
        
        // Make sure given cards are actually open
        if !openCards.contains(card1) || !openCards.contains(card2) || !openCards.contains(card3) {
            print("evaluateSet() -> Given cards are not in play")
            return false
        }
        
        // Evaluate whether or not all variants are ALL-EQUAL or ALL-DIFFERENT.
        func evaluate(_ v1: Card.Variant, _ v2: Card.Variant, _ v3: Card.Variant) -> Bool {
            return (v1==v2 && v1==v3) || ((v1 != v2) && (v1 != v3) && (v2 != v3))
        }
        
        // Evaluate each feature.
        let feature1 = evaluate(card1.feature1, card2.feature1, card3.feature1)
        let feature2 = evaluate(card1.feature2, card2.feature2, card3.feature2)
        let feature3 = evaluate(card1.feature3, card2.feature3, card3.feature3)
        let feature4 = evaluate(card1.feature4, card2.feature4, card3.feature4)
        
        // Whether or not the given cards are a valid set
        let isSet = (feature1 && feature2 && feature3 && feature4)
        
        // Update the score
        score += (isSet ? Score.validSet : Score.invalidSet)
        
        // If cards were a valid set, remove them from the openCards list
        if isSet {
            if let index = openCards.index(of: card1) {
                openCards.remove(at: index)
            }
            if let index = openCards.index(of: card2) {
                openCards.remove(at: index)
            }
            if let index = openCards.index(of: card3) {
                openCards.remove(at: index)
            }
        }
        
        return isSet
    }
    
    ///
    /// Determines how many points different actions take.
    ///
    private struct Score {
        private init() {}
        static let validSet = +3
        static let invalidSet = -5
    }
}

// Assignment 2 (Task #14): "Add a sensible extension to some data structure"

// Extension for simple but useful uitilities
extension Set {
    
    ///
    /// Remove (and return) a random element from self.
    /// - Returns nil if self has no elements
    ///
    mutating public func removeRandomElement() -> Element? {
        let n = Int(arc4random_uniform(UInt32(self.count)))
        let index = self.index(self.startIndex, offsetBy: n)
        if self.count > 0 {
            let element = self.remove(at: index)
            return element
        } else {
            return nil
        }
    }
}
