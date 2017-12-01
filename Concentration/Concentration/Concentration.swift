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
class Concentration {
    
    ///
    /// The cards in the game/board
    ///
    var cards = [Card]()
    
    ///
    /// Handle what to do when a card is chosen
    ///
    func chooseCard(at index: Int) {
        
        // Process an unmatched card
        if !cards[index].isMatched {
            
            // If we have a card facing up already, check if it matches the chosen one
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                
                // If they match, marked them as matched
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                
                // Turn the chosen card face-up
                cards[index].isFaceUp = true
                
                // Since there was a card face-up already (and we selected a new one),
                // we no longer have only 1 card face-up
                indexOfOneAndOnlyFaceUpCard = nil
            }
            // We don't have oneAndOnly cards up
            else {
                
                // Either two cards or no cards are face up
                
                // Flip them all down to be safe
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                
                // Now turn the selected one face-up
                cards[index].isFaceUp = true
                
                // We now have only 1 card face-up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    ///
    /// Build a Concentration game based on the given number of card-pairs
    ///
    init(numberOfPairsOfCards: Int) {
        
        // Create each card in the game
        for _ in 1 ... numberOfPairsOfCards {
            let card = Card()
            
            // Add each pair of cards
            cards.append(card)
            cards.append(card)
        }
        
        // TODO: Shuffle cards
    }
    
    ///
    /// Whether or not we have ONLY one card face-up
    ///
    var indexOfOneAndOnlyFaceUpCard: Int?
}
