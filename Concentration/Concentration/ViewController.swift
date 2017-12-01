//
//  ViewController.swift
//  Concentration
//
//  Created by Ruben on 11/29/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import UIKit

///
/// View-controller of the concentration game
///
class ViewController: UIViewController {

    // (Note)
    // Lazy allows us to use instance variable "cardButtons", because it should
    // be already initialized by the time a lazy var is used.'
    
    ///
    /// Model - The actual game logic is contained in Concentration
    ///
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2) // model

    /// Label that shows how many flips we've done
    @IBOutlet weak var flipCountLabel: UILabel!
    
    /// Array of cards in the UI
    @IBOutlet var cardButtons: [UIButton]!
    
    ///
    /// Handle the touch (press) of a card
    ///
    @IBAction func touchCard(_ sender: UIButton) {
        
        // A card was touched, increment the flip counter
        flipCount += 1
        
        // Get the index of the selected/touched card
        if let cardNumber = cardButtons.index(of: sender) {
            // Tell the model which card was chosen
            game.chooseCard(at: cardNumber)
            
            // Update the view accordingly
            updateViewFromModel()
        }
        else {
            print("Warning! The chosen card was not in cardButtons")
        }
    }
    
    ///
    /// Keeps the view updated based on the model's state
    ///
    func updateViewFromModel() {
        
        // Loop through each card (we care about the index only)
        for index in cardButtons.indices {
            // Get the button at current indext
            let button = cardButtons[index]
            
            // Get the card (from the model) at the current index
            let card = game.cards[index]
            
            // If card is face-up, show it
            if card.isFaceUp {
                // Show the card's emoji
                button.setTitle(emoji(for: card), for: .normal)
                // Set a "face-up" color
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            // If card is not face-up, could be (1) face-up or (2) matched/hidden
            else {
                // No emoji when card is down or already matched
                button.setTitle("", for: .normal)
                
                // If card is matched, hide it (with clear color), else show a "face-down" color
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
    }
    
    ///
    /// This is the "database" of possible card options/images. For each card we encounter
    /// that has no emoji set, we'll pick one from here (and delete it, to avoid duplicates)
    ///
    var emojiChoices = ["🐶","🐱", "🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🦁","🐮", "🐷"]
    
    ///
    /// Each card/button will have a corresponding emoji
    ///
    var emoji = [Int: String]()
 
    ///
    /// Get an emoji for the given card
    ///
    func emoji(for card: Card) -> String {
        
        // If card doesn't have an emoji set, add a random one
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            // Get a random index between 0-number_of_emoji_choises
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            
            // Add the random emoji to this card
            emoji[card.identifier] = emojiChoices[randomIndex]
            
            // Remove emoji from emojiChoices so that it doesn't get selected again
            emojiChoices.remove(at: randomIndex)
        }
        
        // Return the emoji, or "?" if none available
        return emoji[card.identifier] ?? "?"
    }
    
    ///
    /// Track how many flips have been made
    ///
    private var flipCount = 0  {
        didSet {
            // Keep the flipCountLabel in sync
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
}

