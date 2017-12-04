//
//  ViewController.swift
//  PlayingCard
//
//  Created by Ruben on 12/3/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import UIKit

///
/// Main view controller
///
class ViewController: UIViewController {
    
    ///
    /// The deck of cards
    ///
    var deck = PlayingCardDeck()
    
    /// What to do when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        debuggingStuff()
    }
    
    ///
    /// Do some temporary debugging stuff
    ///
    private func debuggingStuff() {
        // Print a few cards
        for _ in 1...10 {
            if let card = deck.draw() {
                print(card)
            }
        }
    }
    
}

