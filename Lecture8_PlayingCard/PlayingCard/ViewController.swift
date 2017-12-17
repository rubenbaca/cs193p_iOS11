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
    /// PlayingCardViews
    ///
    @IBOutlet var cardViews: [PlayingCardView]!
    
    ///
    /// The animator controling the dynamic behaviors
    ///
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    ///
    /// Contains the behaviors that a card must have
    ///
    lazy var cardBehavior = CardBehavior(in: animator)
    
    ///
    /// When view loads, setup the "game"
    ///
    override func viewDidLoad() {
        
        var cards: [PlayingCard] = []
        
        // Create pairs of random cards that the user will try to match
        for _ in 1...((cardViews.count+1)/2) {
            if let card = deck.draw() {
                cards += [card, card]
            }
        }
        
        // Setup each cardView
        for cardView in cardViews {
            // Start facing down
            cardView.isFaceUp = false
            
            // Setup the cardView
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            
            // Add gesture recognizers
            setupGestureRecognizers(to: cardView)
            
            // Add dynamic behavior to the cardView
            cardBehavior.addItem(cardView)
        }
    }
    
    ///
    /// Setup gesture recognizers to the given cardView:
    ///    - Tap Gesture: Flips the card
    ///
    private func setupGestureRecognizers(to cardView: PlayingCardView) {
        let tapToFlip = UITapGestureRecognizer(target: self, action: #selector(flipCard(_:)))
        cardView.addGestureRecognizer(tapToFlip)
    }
    
    ///
    /// Flip card handler. (What to do when a card is flipped)
    ///
    @objc private func flipCard(_ recognizer: UITapGestureRecognizer) {
        
        // Make sure gesture was successful
        guard recognizer.state == .ended else {
            return
        }
        
        // Make sure the gesture comes from a PlayingCardView
        guard let cardView = recognizer.view as? PlayingCardView else {
            return
        }
        
        // Flips should only happen when there are less than 2 cards facing up
        guard faceUpCardViews.count < 2 else {
            return
        }
        
        // Does the actual flip
        processFlip(with: cardView)
    }
    
    ///
    /// Process the flip of the given cardView
    ///
    private func processFlip(with cardView: PlayingCardView) {
        
        // Turn the given cardView face-down (with animation)
        func turnFacingDownWithAnimation(_ cardView: PlayingCardView) {
            UIView.transition(with: cardView,
                              duration: 0.5,
                              options: [.transitionFlipFromLeft, .curveEaseInOut],
                              animations: {
                                // Turn it face-down
                                cardView.isFaceUp = false
                              },
                              completion: { finished in
                                // After turning card face-down, re-add dynamic behavior
                                self.cardBehavior.addItem(cardView)
                              }
            )
        }
        
        // Remove all cards facing-up (with animation)
        func removeFaceUpCardsWithAnimation() {
            
            // The cards to remove and animate
            let cardsToAnimate = self.faceUpCardViews
            
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.6,
                delay: 0,
                options: [],
                animations: {
                    cardsToAnimate.forEach {
                        // (1) Start by making the cards bigger
                        $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                    }
                },
                completion: { _ in
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.75,
                        delay: 0,
                        options: [],
                        animations: {
                            cardsToAnimate.forEach {
                                // (2) Now gradually make the cards very small and transparent
                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                $0.alpha = 0.3
                            }
                        },
                        completion: { _ in
                            cardsToAnimate.forEach {
                                // (3) Hide it
                                $0.isHidden = true
                            }
                        }
                    )
            })
        }
        
        // The animations for processing a flip
        let animations = {
            
            // Does the actual flip
            cardView.isFaceUp = !cardView.isFaceUp
            
            // If we are turning it face-down, re-add behavior
            if !cardView.isFaceUp {
                self.cardBehavior.addItem(cardView)
            }
        }
        
        // The handler for completing the flip animatino
        let completionHandler = { (finished: Bool) in
            // If cards facing up match, we'll remove them (with animation)
            if self.faceUpCardViewsMatch {
                removeFaceUpCardsWithAnimation()
            }
            // The pair of cards facing up don't match, turn them face-down (with animation)
            else if self.faceUpCardViews.count == 2 {
                self.faceUpCardViews.forEach {
                    turnFacingDownWithAnimation($0)
                }
            }
        }
        
        // Do the flip-animations "animations" and complete them with "completionHandler"
        UIView.transition(with: cardView,
                          duration: 0.5,
                          options: [.transitionFlipFromLeft, .curveEaseInOut],
                          animations: animations,
                          completion: completionHandler)
        
        // If the cards is facing up, remove the dynamic behaviors
        if cardView.isFaceUp {
            cardBehavior.removeItem(cardView)
        }
    }
    
    ///
    /// List of cards facing-up
    ///
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter {
            $0.isFaceUp &&
            !$0.isHidden &&
            // Ugly design
            $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) &&
            $0.alpha == 1
        }
    }
    
    ///
    /// Whether or not there are 2 cards facing-up that are a match
    ///
    private var faceUpCardViewsMatch: Bool {
        if faceUpCardViews.count != 2 {
            return false
        }
        return (faceUpCardViews[0].rank == faceUpCardViews[1].rank) &&
               (faceUpCardViews[0].suit == faceUpCardViews[1].suit)
    }
}

