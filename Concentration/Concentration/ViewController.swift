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
    var game: Concentration!
    
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
    var theme: Theme!

    /// Label that shows how many flips we've done
    @IBOutlet weak var flipCountLabel: UILabel!
    
    // Programming assignment 1 (Task #7)
    // "Add a game score label to your UI."
    
    /// Label that shows the current score
    @IBOutlet weak var scoreLabel: UILabel!
    
    /// Array of cards in the UI
    @IBOutlet var cardButtons: [UIButton]!
    
    ///
    /// Handle the touch (press) of a card
    ///
    @IBAction func touchCard(_ sender: UIButton) {
        // Get the index of the selected/touched card
        if let cardNumber = cardButtons.index(of: sender) {
            // Tell the model which card was chosen
            game.chooseCard(at: cardNumber)
            
            // Update the view accordingly
            updateUIFromModel()
        }
        else {
            print("Warning! The chosen card was not in cardButtons")
        }
    }
    
    // Programming assignment 1 (Task #3):
    // Add a “New Game” button to your UI which ends the current game in progress and
    // begins a brand new game.
    
    /// Start a new game
    @IBAction func newGame() {
        // Do initial setup
        initialSetup()
    }
    
    ///
    /// Setups a new game
    ///
    private func initialSetup() {
        // Create new Concentration game
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)
        
        // Choose a random theme
        theme = themes[Int(arc4random_uniform(UInt32(themes.count)))]
        
        // Match board color (view's background) with the current theme color
        self.view.backgroundColor = theme.boardColor
        
        // Get emojis for each card
        mapCardsToEmojis()
        
        // Update cards view
        updateUIFromModel()
    }
    
    ///
    /// Keeps the UI updated based on the model's state
    ///
    private func updateUIFromModel() {
        
        // Update flip count label
        flipCountLabel.text = "Flip count: \(game.flipCount)"
        
        // Update the current score
        scoreLabel.text = "Score: \(game.score)"
        
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
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : theme.cardColor
            }
        }
    }
    
    // Setup/configure stuff as soon as the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do initialSetup
        initialSetup()
    }
    
    ///
    /// Each card/button will have a corresponding emoji
    ///
    private var emoji = [Int: String]()
 
    ///
    /// Get an emoji for the given card
    ///
    private func emoji(for card: Card) -> String {
        // Return the emoji, or "?" if none available
        return emoji[card.identifier] ?? "?"
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
            if !emojis.isEmpty, emoji[card.identifier] != nil {
                // Assign emoji
                emoji[card.identifier] = emojis.removeFirst()
            }
            else {
                emoji[card.identifier] = "?"
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
    /// Available themes the app supports.
    ///
    /// Add more themes as you please.
    ///
    private var themes: [Theme] = [
        Theme(name: "Christmas",
              boardColor: #colorLiteral(red: 0.9678710938, green: 0.9678710938, blue: 0.9678710938, alpha: 1),
              cardColor: #colorLiteral(red: 0.631328125, green: 0.1330817629, blue: 0.06264670187, alpha: 1),
              emojis: ["🎅", "🤶", "🧝", "🧦", "🦌", "🍪", "🥛", "🍷", "⛪", "🌟", "❄", "⛄",
                       "🎄", "🎁", "🔔", "🕯"]
        ),
        Theme(name: "Halloween",
              boardColor: #colorLiteral(red: 1, green: 0.8556062016, blue: 0.5505848702, alpha: 1),
              cardColor: #colorLiteral(red: 0.7928710937, green: 0.373980853, blue: 0, alpha: 1),
              emojis: ["💀", "👻", "👽", "🧙", "🧛", "🧟", "🦇", "🕷", "🕸", "🛸", "🎃", "🎭",
                       "🗡", "⚰"]
        ),
        Theme(name: "Faces",
              boardColor: #colorLiteral(red: 0.9959731026, green: 1, blue: 0.8252459694, alpha: 1),
              cardColor: #colorLiteral(red: 0.8265820312, green: 0.7249050135, blue: 0.4632316118, alpha: 1),
              emojis: ["😀", "😁", "😂", "🤣", "😃", "😄", "😅", "😆", "😉", "😊", "😋", "😎",
                       "😍", "😘", "😗", "😙", "😚", "☺", "🙂", "🤗", "🤩", "🤔", "🤨", "😐",
                       "😑", "😶", "🙄", "😏", "😣", "😥", "😮", "🤐", "😯", "😪", "😫", "😴",
                       "😌", "😛", "😜", "😝", "🤤", "😒", "😓", "😔", "😕", "🙃", "🤑", "😲",
                       "☹", "🙁", "😖", "😞", "😟", "😤", "😢", "😭", "😦", "😧", "😨", "😩",
                       "🤯", "😬", "😰", "😱", "😳", "🤪", "😵", "😡", "😠", "🤬", "😷", "🤒",
                       "🤕", "🤢", "🤮", "🤧", "😇", "🤠", "🤡", "🤥", "🤫", "🤭", "🧐", "🤓"]
        ),
        Theme(name: "Animals",
              boardColor: #colorLiteral(red: 0.8306297664, green: 1, blue: 0.7910112419, alpha: 1),
              cardColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),
              emojis: ["🙈", "🙉", "🙊", "💥", "💦", "💨", "💫", "🐵", "🐒", "🦍", "🐶", "🐕",
                       "🐩", "🐺", "🦊", "🐱", "🐈", "🦁", "🐯", "🐅", "🐆", "🐴", "🐎", "🦄",
                       "🦓", "🐮", "🐂", "🐃", "🐄", "🐷", "🐖", "🐗", "🐽", "🐏", "🐑", "🐐",
                       "🐪", "🐫", "🦒", "🐘", "🦏", "🐭", "🐁", "🐀", "🐹", "🐰", "🐇", "🐿",
                       "🦔", "🦇", "🐻", "🐨", "🐼", "🐾", "🦃", "🐔", "🐓", "🐣", "🐤", "🐥"]
        ),
        ]
}

