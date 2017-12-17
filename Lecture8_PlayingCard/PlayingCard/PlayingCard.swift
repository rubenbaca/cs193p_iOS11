//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Ruben on 12/3/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import Foundation

///
/// Represents a playing card
///
struct PlayingCard {
    
    /// Suit of the card
    var suit: Suit
    
    /// Rank of the card
    var rank: Rank
    
    ///
    /// Represents a Suit in a playing card
    ///
    enum Suit: String {
        case spades     = "♠️"
        case hearts     = "♥️"
        case clubs      = "♣️"
        case diamonds   = "♦️"
        
        ///
        /// Array containing all possible suits
        ///
        static var all: [Suit] = [.spades, .hearts, .clubs, .diamonds]
    }
    
    ///
    /// Represents the Rank in a playing card
    ///
    enum Rank {
        case ace
        case face(String) // ugly design
        case numeric(Int)
        
        ///
        /// The order of each Rank
        ///
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0 // ugly design
            }
        }
        
        ///
        /// Array containing all possible suits
        ///
        static var all: [Rank] {
            // Ace
            var allRanks: [Rank] = [.ace]
            
            // 2...10
            for pips in 2...10 {
                allRanks.append(.numeric(pips))
            }
            
            // Jack, Queen, King
            allRanks += [.face("J"), .face("Q"), .face("K")]
            return allRanks
        }
    }
}

// Make `PlayingCard` confrom to `CustomStringConvertible`
extension PlayingCard: CustomStringConvertible {
    ///
    /// String representation of a `PlayingCard`
    ///
    var description: String {
        return "\(rank)\(suit)"
    }
}

// Make `PlayingCard.Suit` confrom to `CustomStringConvertible`
extension PlayingCard.Suit: CustomStringConvertible {
    ///
    /// String representation of a `PlayingCard.Suit`
    ///
    var description: String {
        return rawValue
    }
}

// Make `PlayingCard.Rank` confrom to `CustomStringConvertible`
extension PlayingCard.Rank: CustomStringConvertible {
    ///
    /// String representation of a `PlayingCard.Rank`
    ///
    var description: String {
        switch self {
        case .ace: return "A"
        case .numeric(let pips): return String(pips)
        case .face(let kind): return kind
        }
    }
}
