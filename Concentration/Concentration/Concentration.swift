//
//  Concentration.swift
//  Concentration
//
//  Created by Ruben on 11/30/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import Foundation

///
/// Models a "Concentration" game
///
/// Concentration, also known as Match Match, Match Up, Memory, or simply Pairs, is a card game
/// in which all of the cards are laid face down on a surface and two cards are flipped face up
/// over each turn. The object of the game is to turn over pairs of matching cards.
/// Concentration can be played with any number of players or as solitaire. It is a particularly
/// good game for young children, though adults may find it challenging and stimulating as well.
///
struct Concentration {
    
    ///
    /// The cards in the game/board
    ///
    private(set) var cards = [Card]()
    
    // Programming assignment 1 (Task #8)
    // "Tracking the flip count almost certainly does not belong in your Controller"
    
    ///
    /// Track the number of flips the user has done
    ///
    private(set) var flipCount = 0
    
    ///
    /// Keep track of the game's score
    ///
    var score = 0
    
    ///
    /// Handle what to do when a card is chosen
    ///
    mutating func chooseCard(at index: Int) {
        
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index): Invalid argument")
        
        // If chosen card is already matched, ignore it (return)
        if cards[index].isMatched {
            return
        }
        
        // Increment flipCount
        flipCount += 1
        
        // If we have a card facing up already, check if it matches the chosen one
        if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
            
            // If they match, mark them as matched
            if cards[matchIndex] == cards[index] {
                cards[matchIndex].isMatched = true
                cards[index].isMatched = true
                
                // Increase the score
                score += Points.foundMatch
            }
            // Chosen pair of cards didn't match
            else {
                // Penalize  1 point for every previously seen card that is involved in a mismatch.
                if seenCards.contains(index) {
                    score -= Points.missMatchPenalty
                }
                // Penalize 1 point for every previously seen card that is involved in a mismatch.
                if seenCards.contains(matchIndex) {
                    score -= Points.missMatchPenalty
                }
            }
            
            // Both cards have been seen by now
            seenCards.insert(index)
            seenCards.insert(matchIndex)
            
            // Turn the chosen card face-up
            cards[index].isFaceUp = true
        }
        else {
            // We now have only 1 card face-up
            indexOfOneAndOnlyFaceUpCard = index
        }
    }
    
    ///
    /// Build a Concentration game based on the given number of card-pairs
    ///
    init(numberOfPairsOfCards: Int) {
        
        assert(numberOfPairsOfCards > 0, "Concentration(numberOfPairsOfCards: \(numberOfPairsOfCards): Must provide at least 1 pair of cards.")
        
        // Create each card in the game
        for _ in 1 ... numberOfPairsOfCards {
            let card = Card()
            
            // Add each pair of cards
            cards.append(card)
            cards.append(card)
        }
        
        // Programming assignment 1 (Task #4)
        // "Shuffle the cards in Concentration’s init() method."
        cards.shuffle()
    }
    
    ///
    /// Whether or not we have ONLY one card face-up
    ///
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            // Turn all cards face-down, except the oneAndOnly one
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    ///
    /// Keep track of which cards have been seen, for instance, to
    /// penalize the player if they mismatch cards already seen.
    ///
    private var seenCards: Set<Int> = []
    
    ///
    /// Defines how many points certain actions take
    ///
    private struct Points {
        /// Increase score when user found a match
        static let foundMatch = 2
        /// Decrease score when a prev. seen card is involved in a mismatch
        static let missMatchPenalty = 1
    }
}
