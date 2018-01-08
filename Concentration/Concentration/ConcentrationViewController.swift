//
//  ConcentrationViewController.swift
//  Concentration
//
//  Created by Ruben on 11/29/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import UIKit

///
/// View-controller of the concentration game
///
class ConcentrationViewController: UIViewController {

    // (Note)
    // Lazy allows us to use instance variable "cardButtons", because it should
    // be already initialized by the time a lazy var is used.'
    
    ///
    /// Model - The actual game logic is contained in Concentration
    ///
    private  var game: Concentration!
    
    // Programming assignment 1 (Task #4 & extra-credit #1)
    //
    // "Give your game the concept of a 'theme'. A theme determines the set of emoji from
    // which cards are chosen"
    //
    // +Extra credit:
    // "Change the background and the 'card back color' to match the theme"
    
    ///
    /// The theme determines the game's look and feel.
    ///
    lazy var theme: Theme = defaultTheme

    /// Label that shows how many flips we've done
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    // Programming assignment 1 (Task #7)
    // "Add a game score label to your UI."
    
    /// Label that shows the current score
    @IBOutlet private weak var scoreLabel: UILabel!
    
    /// Array of cards in the UI
    @IBOutlet private var cardButtons: [UIButton]!
    
    // The cardButtons that are visible (Ugh, this is so ugly)
    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter { !$0.superview!.isHidden }
    }
    
    // Update UI every time we get subviews laid out
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUIFromModel()
    }
    
    ///
    /// Handle the touch (press) of a card
    ///
    @IBAction private func touchCard(_ sender: UIButton) {
        // Get the index of the selected/touched card
        if let cardNumber = visibleCardButtons.index(of: sender) {
            // Tell the model which card was chosen
            game.chooseCard(at: cardNumber)
            
            // Update the view accordingly
            updateUIFromModel()
        }
        else {
            print("Warning! The chosen card was not in visibleCardButtons")
        }
    }
    
    // Programming assignment 1 (Task #3):
    // Add a “New Game” button to your UI which ends the current game in progress and
    // begins a brand new game.
    
    /// Start a new game
    @IBAction private func newGame() {
        // Do initial setup
        initialSetup()
    }
    
    ///
    /// The number of pairs of cards in the game
    ///
    var numberOfPairsOfCards: Int {
        return (visibleCardButtons.count + 1)/2
    }
    
    ///
    /// Setups a new game
    ///
    private func initialSetup() {
        // Create new Concentration game
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        
        // Match board color (view's background) with the current theme color
        self.view.backgroundColor = theme.boardColor
        
        // Get emojis for each card
        mapCardsToEmojis()
        
        // Update cards view
        updateUIFromModel()
    }
    
    ///
    /// Function that creates an attributed string (i.e. string with "visual" style),
    /// which is explained (and used) in Lecture #4: "More Swift"
    ///
    private func attributedString(_ text: String) -> NSAttributedString {
        let attributes: [NSAttributedStringKey : Any] = [
            .strokeColor : UIColor.red,
            .strokeWidth : -2.0
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    ///
    /// Keeps the UI updated based on the model's state
    ///
    private func updateUIFromModel() {
        
        // (Intentionally skipping this variation based on size classes)
//        // Example to vary this based on size class:
//        if traitCollection.verticalSizeClass == .compact {
//            flipCountLabel.attributedText = attributedString("Flip count: \(game.flipCount)")
//        }
//        else {
//            flipCountLabel.attributedText = attributedString("Flip count:\n\(game.flipCount)")
//        }
        
        // Update flip count label (using NSAttributedString as seen on Lecture #4)
        flipCountLabel.attributedText = attributedString("Flip count: \(game.flipCount)")

        // Update the current score
        scoreLabel.text = "Score: \(game.score)"
        
        // Loop through each card (we care about the index only)
        for index in visibleCardButtons.indices {
            // Get the button at current indext
            let button = visibleCardButtons[index]
            
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
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : theme.cardColor
            }
        }
    }

// (Intentionally skipping this variation based on size classes)
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        updateUIFromModel()
//    }
    
    // Setup/configure stuff as soon as the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do initialSetup
        initialSetup()
    } 
    
    ///
    /// Each card/button will have a corresponding emoji
    ///
    private var emoji = [Card: String]()
 
    ///
    /// Get an emoji for the given card
    ///
    private func emoji(for card: Card) -> String {
        // Return the emoji, or "?" if none available
        return emoji[card] ?? "?"
    }
    
    ///
    /// Assign an emoji for each card identifier
    ///
    private func mapCardsToEmojis() {
        
        // List of emojis available for the current theme
        var emojis = theme.emojis
        
        // Suffle them (to have slighlty different emojis with each new game)
        emojis.shuffle()
        
        for card in game.cards {
            // Make sure emojis has item(s) and the card is not set yet
            if !emojis.isEmpty, emoji[card] != nil {
                // Assign emoji
                emoji[card] = emojis.removeFirst()
            }
            else {
                emoji[card] = "?"
            }
        }
    }
    
    ///
    /// Represents the game's theme.
    ///
    /// For instance, a "halloween" theme might contain a dark (black) board with orange
    /// cards and a set of "scary" emojis.
    ///
    struct Theme {
        /// The name of the theme (i.e. to show it on screen or something)
        var name: String
        
        /// The color of the board
        var boardColor: UIColor
        
        /// The color of the card's back
        var cardColor: UIColor
        
        /// Array of available emojis fot the theme
        var emojis: [String]
    }
    
    ///
    /// The default theme to use
    ///
    private var defaultTheme = Theme(name: "Default", boardColor: #colorLiteral(red: 0.9678710938, green: 0.9678710938, blue: 0.9678710938, alpha: 1), cardColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                                    emojis: ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇",
                                             "🍓", "🍈", "🍒", "🍑", "🍍", "🥝", "🥑", "🍅",])
}
