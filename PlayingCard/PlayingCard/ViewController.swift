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
    /// The deck of cards (model)
    ///
    var deck = PlayingCardDeck()
    
    ///
    /// The playing card view (view)
    ///
    @IBOutlet weak var playingCardView: PlayingCardView! {
        didSet { setupGestureRecognizers() }
    }
    
    ///
    /// Flip the card
    ///
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        // Make sure tap was successful
        if sender.state == .ended {
            playingCardView.isFaceUp = !playingCardView.isFaceUp
        }
    }
    
    ///
    /// Get the next card on the deck
    ///
    @objc private func nextCard() {
        // Try to draw a card
        if let card = deck.draw() {
            // Configure the view to show the new card
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
        }
    }
    
    ///
    /// Setup gesture recognizers on the playing card:
    ///   - Swipe: Go to next card in the deck
    ///   - Pinch: Zoom the card's face
    ///
    /// Note: Tap gesture recognizer (to flip the card) was added
    /// using interface builder.
    ///
    private func setupGestureRecognizers() {
        // Swipe gesture recognizer to go to next card
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
        swipe.direction = [.left, .right]
        playingCardView.addGestureRecognizer(swipe)
        
        // Pinch gesture recognizer to zoom the card's face
        let pinch = UIPinchGestureRecognizer(
            target: playingCardView,
            action: #selector(playingCardView.adjustFaceCardScale(gestureRecognizer:))
        )
        playingCardView.addGestureRecognizer(pinch)
    }
    
}

