//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by Ruben on 12/3/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import Foundation

///
/// Represents a deck of playing cards
///
struct PlayingCardDeck {
    
    ///
    /// Create a new deck of cards
    ///
    init() {
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }

    ///
    /// The collection of cards
    ///
    private(set) var cards = [PlayingCard]()
    
    ///
    /// Draw a card from the deck
    ///
    mutating func draw() -> PlayingCard? {
        // If there are cards, return a random one
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        }
        // No more cards available
        return nil
    }
}
