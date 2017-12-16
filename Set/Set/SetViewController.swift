//
//  SetViewController.swift
//  Set
//
//  Created by Ruben on 12/7/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import UIKit

///
/// Main view controller for a Set game.
///
class SetViewController: UIViewController {
    
    // MARK: IBOutlets
    
    ///
    /// The boardView is a view containing all the cardViews
    ///
    // Note: This view is transparent in InterfaceBuilder
    @IBOutlet private weak var boardView: UIView!
    
    ///
    /// UILabel showing the current score
    ///
    @IBOutlet private weak var scoreLabel: UILabel!
    
    // MARK: IBActions
    
    ///
    /// What to do when user presses "New Game"
    ///
    @IBAction private func newGameButtonPressed() {
        newGame()
    }
    
    ///
    /// What to do when user presses "Deal"
    ///
    @IBAction private func deal() {
        cleanupBoard()
        game.draw(n: 3)
        updateUI()
    }
    
    // MARK: Private stored-properties
    
    ///
    /// Contains the core functionality of a Set game
    ///
    private var game: SetGame!
    
    ///
    /// Keep track of which Card represents which CardView. The cardViews are the actual
    /// UIViews shown on screen, and the Card is what the view represents.
    ///
    private var board: [Card:CardView] = [:]
    
    ///
    /// The intitial number of cards to open
    ///
    private let initialCards = 9
    
    // MARK: Private computed-properties
    
    ///
    /// Returns the list of cards that are currently selected
    ///
    private var selectedCards: [Card] {
        var result = [Card]()
        for (card, cardView) in board {
            if cardView.isSelected {
                result.append(card)
            }
        }
        return result
    }
    
    // MARK: Method overrides
    
    ///
    /// What to do when view loads (i.e. start a game)
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
    }
    
    ///
    /// What to do when view does subview layout (i.e. update UI when device rotates)
    ///
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUI()
    }
    
    // MARK: Private enums
    
    ///
    /// Create a new game. Updates the boardView, board, scoreLabel, etc.
    ///
    private func newGame() {
        boardView.subviews.forEach { $0.removeFromSuperview() }
        board = [:]
        game = SetGame()
        game.draw(n: initialCards)
        updateUI()
    }
    
    ///
    /// Update the UI to stay in sync with the model.
    ///
    private func updateUI() {
        // Update UILabel showing the current score
        updateScoreLabel()
        
        // Update the `board` dictionary with the open cards from `game.openCards`
        // (i.e. if new cards were open/dealt, we need to add them to the `board` dictionary)
        updateBoard()
        
        // If `board` contains cards not shown on the boardView, add them.
        // (i.e. if new cards were open/dealt, we need to add them to the boardView)
        updateBoardView()
    }
    
    ///
    /// Update the scoreLabel to show the current score
    ///
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }
    
    ///
    /// Add missing cards from game.openCards into the `board` dictionary. For instance, if new
    /// cards were dealt recently (game.draw()), we need to add them into `board`.
    ///
    private func updateBoard() {
        for card in game.openCards {
            if board[card] == nil {
                board[card] = getCardView(for: card)
            }
        }
    }
    
    ///
    /// Update the cardViews from the boardView
    ///
    private func updateBoardView() {
        
        // We need a grid to display cards on screen
        guard let grid = gridForCurrentBoard() else {
            return
        }
        
        // Update each cardView
        for (i, card) in board.enumerated() {
            
            // Get a frame to place the cardView
            if let cardFrame = grid[i] {
                
                let cardView = card.value
                
                // Add a little margin to have spacing between cards
                let margin = min(cardFrame.width, cardFrame.height) * 0.05
                cardView.frame = cardFrame.insetBy(dx: margin, dy: margin)
                
                // If the cardView hasn't been added to the boardView, add it
                // (i.e. when new cards have been recently dealt/opened)
                if !boardView.subviews.contains(cardView) {
                    boardView.addSubview(cardView)
                }
            }
        }
    }
    
    ///
    /// Returns a `Grid` object based on the current number of cards present
    /// in the board
    ///
    private func gridForCurrentBoard() -> Grid? {
        
        // The number of rows and columns we want
        let (rows, columns) = getRowsAndColumns(numberOfCards: board.count)
        
        // We need at list 1x1 grid to have a valid grid
        guard rows>0, columns>0 else {
            return nil
        }
        
        return Grid(layout: .dimensions(rowCount: rows, columnCount: columns), frame: boardView.bounds)
    }
    
    ///
    /// Get a `CardView` object for the given `Card` with all the appropriate gesture recognizers from
    /// `addGestureRecognizers(_:)`
    ///
    private func getCardView(for card: Card) -> CardView {
        
        // The view to populate/return
        let cardView = CardView(frame: CGRect())
        
        // Color
        switch card.feature1 {
        case .v1: cardView.color = .red
        case .v2: cardView.color = .purple
        case .v3: cardView.color = .green
        }
        
        // Shade
        switch card.feature2 {
        case .v1: cardView.shade = .solid
        case .v2: cardView.shade = .shaded
        case .v3: cardView.shade = .unfilled
        }
        
        // Shape
        switch card.feature3 {
        case .v1: cardView.shape = .oval
        case .v2: cardView.shape = .diamond
        case .v3: cardView.shape = .squiggle
        }
        
        // Number of elements in the card
        switch card.feature4 {
        case .v1: cardView.elements = .one
        case .v2: cardView.elements = .two
        case .v3: cardView.elements = .three
        }
        
        // Add tap-to select gestureRecognizer
        addGestureRecognizers(cardView)
        
        return cardView
    }
    
    ///
    /// Add all gesture recognizers that a card must handle:
    ///    - Tap: Select/deselect card
    ///
    private func addGestureRecognizers(_ cardView: CardView) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapCard(recognizer:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        cardView.addGestureRecognizer(tapRecognizer)
    }
    
    ///
    /// What to do when the user taps on a card
    ///
    @objc private func tapCard(recognizer: UITapGestureRecognizer) {
        
        // Make sure the gesture was successful
        guard recognizer.state == .ended else {
            print("Tap gesture cancelled/failed")
            return
        }
        
        // We want to select/deselect the cardView where the gesture is coming from
        guard let cardView = recognizer.view as? CardView else {
            print("tapCard called from something not a CardView")
            return
        }
        
        // Toggle card selection
        cardView.isSelected = !cardView.isSelected
        
        // Process the board
        processBoard()
    }
    
    ///
    /// Process the current board's state:
    ///    - Cleanup board (remove matched cards from board, de-highlight unmatched cards)
    ///    - If there are three cards selected, process them (i.e. check for match/mismatch)
    ///
    private func processBoard() {
        
        // Cleanup the board (i.e. remove any matched cards or de-highlight unmatched ones)
        cleanupBoard()
        
        // If there are three selected cards on the board, see if they match or not
        if selectedCards.count == 3 {
            
            // Check if selected cards are a set
            let isSet = game.evaluateSet(selectedCards[0], selectedCards[1], selectedCards[2])
            
            // Match!
            if isSet {
                match(selectedCards)
            }
                // Not a match :(
            else {
                mismatch(selectedCards)
            }
            
            // Keep UI in sync with the model
            updateUI()
        }
    }
    
    ///
    /// Cleanup the board
    ///
    private func cleanupBoard() {
        
        // Process each card/cardView in the board
        for (card, cardView) in board {
            
            // If the game doesn't contain the card, we need to remove it from the baordView.
            // This happends when the card is part of a currently highlighed set that was matched
            // on the previous turn.
            if !game.openCards.contains(card) {
                // Remove value from board
                board.removeValue(forKey: card)
                // Remove cardView from superView
                cardView.removeFromSuperview()
                // We just removed a cardView from the superView, update UI!
                updateUI()
            }
            
            // Set card to be in "regular" state (i.e. not mathced/mismatched)
            // (matched ones shoud no longer be on screen, but mismatched ones should,
            // and we want to "reset" them to a regular state)
            cardView.cardState = .regular
        }
    }
    
    ///
    /// Process the given cards as "matched". This means:
    ///    - Deselect card
    ///    - Set it into a "matched" state (i.e. green/success highlight color).
    ///
    private func match(_ cards: [Card]) {
        for card in cards {
            if let cardView = board[card] {
                cardView.isSelected = false
                cardView.cardState = .matched
            }
        }
    }
    
    ///
    /// Process the given cards as "mismatched". This means:
    ///    - Deselect card
    ///    - Set it into a "mismatched" state (i.e. red/failure highlight color).
    ///
    private func mismatch(_ cards: [Card]) {
        for card in cards {
            if let cardView = board[card] {
                cardView.isSelected = false
                cardView.cardState = .mismatched
            }
        }
    }
    
    ///
    /// Get the number of rows and columns that will correctly fit the given numberOfCards.
    ///
    private func getRowsAndColumns(numberOfCards: Int) -> (rows: Int, columns: Int) {
        
        // For 0 cards, we don't need any rows/columns
        if numberOfCards <= 0 {
            return (0, 0)
        }
        
        // TODO: The following logic is a "get it to work in 5 min." approach, so you may
        // want to review/change it. (At least add comments explaining it?)
        
        var rows = Int(sqrt(Double(numberOfCards)))
        
        if (rows*rows) < numberOfCards {
            rows += 1
        }
        
        var columns = rows
        
        if ( rows * (columns-1) ) >= numberOfCards {
            columns -= 1
        }
        
        return (rows, columns)
    }
}

// Small utility extension(s) in CardView relevant only to the class in
// this file (the SetViewController)
fileprivate extension CardView {
    
    ///
    /// Represents the state of a card in the current game:
    ///    - A "matched" card will show in a "green/success" accent/highlight color.
    ///    - A "mismatched" card will show in a "red/failed" accent/highlight color.
    ///    - A "regular" card will show with no accent/highlight color.
    ///
    enum CardState {
        // Regular state (i.e. when starting a game)
        case regular
        // Matched state (the card was correclty selected as part of a valid set)
        case matched
        // Mismatched state (the card was incorreclty selected as part of a set)
        case mismatched
    }
    
    ///
    /// The current state of the card
    ///
    var cardState: CardState {
        
        get {
            // Mismatch
            if layer.borderColor == #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor {
                return .mismatched
            }
                // Match
            else if layer.borderColor == #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor {
                return .matched
            }
                // Regular
            else {
                return .regular
            }
        }
        
        set {
            switch newValue {
                
            // Regular state (no accent color)
            case .regular:
                layer.borderWidth = 0.0
                layer.borderColor = UIColor.clear.cgColor
                
            // Matched state (green/success color)
            case .matched:
                layer.borderWidth = bounds.width * 0.1
                layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor
                
            // Mismatched state (red/fail color)
            case .mismatched:
                layer.borderWidth = bounds.width * 0.1
                layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor
            }
        }
    }
}
