//
//  ViewController.swift
//  Set
//
//  Created by Ruben on 12/7/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import UIKit

///
/// Main view controller for a Set game.
///
class ViewController: UIViewController {
    
    ///
    /// Provides the core functionality of a set game (Model)
    ///
    private var game: SetGame!
    
    ///
    /// UI Label that keeps track of the score
    ///
    @IBOutlet private weak var scoreLabel: UILabel!
    
    ///
    /// Array of UI cardButtons
    ///
    @IBOutlet private var cardButtons: [CardButton]!
    
    ///
    /// Start a new game
    ///
    @IBAction private func newGame() { // Assignment 2 (Task #16): "New-Game button"
        initialSetup()
    }
    
    ///
    /// An array containing all the selected cards from the board
    ///
    private var selectedCards: [Card] {
        
        var cards = [Card]()
        
        // Check each cardButton and append the selected ones
        for cardButton in cardButtons {
            if cardButton.cardIsSelected {
                if let card = cardButton.card {
                    cards.append(card)
                }
            }
        }
        return cards
    }
    
    // Assignment 2 (Task #4): "You will also need a 'Deal 3 More Cards' button"
    
    ///
    /// Deal more cards.
    ///
    /// If there's room for more cards (and there are enough cards on the deck),
    /// this method will add them to the board.
    ///
    /// Note that if there are 3 matching cards showing on the board, we'll replace
    /// them with the new dealt cards.
    ///
    @IBAction private func deal() {
        
        // Assignment 2 (Task #9):
        // "When the Deal 3 More Cards button is pressed either a) replace the selected cards if
        // they are a match or b) add 3 cards to the game."
        
        // Before dealing more cards, we want to cleanup the board (i.e. if the board has
        // a set selected, the cleanup method will replace them with new ones.)
        let replacedCards = cleanup()
        
        // Do not deal more cards if cleanup already did it.
        if replacedCards > 0 {
            print("Not dealing because cleanup already replaced \(replacedCards) cards")
            return
        }
        
        // How many cards do we want to deal?
        let maxCardsToDeal = 3
        
        // How many cards have we dealt?
        var dealtCards = 0
        
        for cardButton in cardButtons {
            
            // Stop when we've dealt enough cards
            if dealtCards == maxCardsToDeal {
                return
            }
            
            // If the cardbutton is not set, we can use it to display a new card
            if cardButton.card == nil {
                // Try to get a new card from the deck
                if let newCard = game.draw() {
                    // Add the new card in the available button
                    cardButton.card = newCard
                    // Track how many cards we've dealt
                    dealtCards += 1
                }
            }
        }
    }
    
    ///
    /// Handle the touch/press of a card
    ///
    @IBAction private func touchCard(_ sender: CardButton) {
        
        // First, cleanup any matching/mismatching sets that were previously selected
        cleanup() // Assignment 2 (Task #7-8)

        // Toogle the card's selection state (either select it or de-select it)
        sender.toggleCardSelection() // Assignment 2 (Task #5): "Allow the user to select cards..."
        
        // Is this the third selected card?
        if selectedCards.count == 3 {
            
            // Check if selected cards are a valid set
            let isSet = game.evaluateSet(selectedCards[0], selectedCards[1], selectedCards[2])
            
            // Assignment 2 (Task #6):
            //"After 3 cards have been selected, you must indicate whether those 3 cards are a match"
            
            if isSet {
                // Handle a match/set
                match(selectedCards)
            }
            else {
                // Handle a mismatch/invalid-set
                mismatch(selectedCards)
            }
            
            // Update score accordingly
            updateScoreLabel()
        }
    }
    
    ///
    /// Handle a match/set
    ///
    private func match(_ cards: [Card]) {
        // Process each matched card
        for card in cards {
            // Update cardButton to reflect a match
            if let cardButton = getButton(for: card) {
                // De-select it
                cardButton.cardIsSelected = false
                // Show a "success/match" background color
                cardButton.backgroundColor = CardColor.match
            }
        }
    }
    
    ///
    /// Handle a mismatch/invalid-set
    ///
    private func mismatch(_ cards: [Card]) {
        // Process each mismatched card
        for card in cards {
            // Update cardButton to reflect a mismatch
            if let cardButton = getButton(for: card) {
                // De-select it
                cardButton.cardIsSelected = false
                // Show a "failure/mismatch" background color
                cardButton.backgroundColor = CardColor.mismatch
            }
        }
    }
    
    ///
    /// Get the cardButton that contains the given card
    ///
    private func getButton(for card: Card) -> CardButton? {
        for cardButton in cardButtons {
            if cardButton.card == card {
                return cardButton
            }
        }
        return nil
    }

    ///
    /// Replace the card in the given cardButton. If there are no more
    /// cards available, hide it.
    ///
    private func replaceCardButtonOrHideIt(in cardButton: CardButton) {
        
        // Get a new card from the game
        if let newCard = game.draw() {
            cardButton.card = newCard
        }
        else {
            print("No cards in deck to replace, hiding card button")
            cardButton.card = nil
        }
        
    }

    ///
    /// Cleanup cardButtons. It will cleanup any "match/mismatch" highlighted cardButton.
    /// - If cardButton has a "match" highlight, replace it with a new card (hide it if no more
    ///   cards available).
    /// - If cardButton has a "mismatch" highlight, de-highlight it.
    ///
    /// Return the number of replaced cards (or hidden ones).
    ///
    @discardableResult
    private func cleanup() -> Int {
        
        // Count (and return) the number of replaced cards
        // (We'll replaced any mathced cards from the board)
        var cardsReplaced = 0
        
        // Cleanup each cardButton
        for cardButton in cardButtons {
            
            // De-highlight button
            cardButton.backgroundColor = CardColor.defaultColor
            
            // If cardButton has a card set, process it
            if cardButton.card != nil {
                // Replace cards that are no longer open (i.e. the ones that are 'matched')
                if !game.openCards.contains(cardButton.card!) {
                    replaceCardButtonOrHideIt(in: cardButton)
                    cardsReplaced += 1
                }
            }
        }
        return cardsReplaced
    }

    ///
    /// What to do when the view loads
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do inital setup
        initialSetup()
    }
    
    ///
    /// Setup a new game:
    ///    - CardButtons
    ///    - Update UI elements (i.e. score label)
    ///    - Etc.
    ///
    private func initialSetup() {
        
        // Hide/deselect all buttons
        for cardButton in cardButtons {
            cardButton.card = nil
            cardButton.cardIsSelected = false
            cardButton.backgroundColor = CardColor.defaultColor
        }
        
        // Create a new game and open the inital number of cards
        game = SetGame()
        game.draw(n: initialCards)
        
        // Update score label
        updateScoreLabel()
        
        // Start with 12 cards
        for (i, card) in game.openCards.enumerated() {
            cardButtons[i].card = card
        }
    }
    
    ///
    /// Keep scoreLabel in sync with the model
    ///
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }

    ///
    /// Card colors for different states
    ///
    private struct CardColor {
        private init() {}
        static let mismatch: UIColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        static let match: UIColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        static let defaultColor: UIColor = .white
    }
    
    ///
    /// The intial number of cards open/face-up
    ///
    private let initialCards = 12  // Assignment 2 (Task #3): "Deal 12 cards only to start."

}
