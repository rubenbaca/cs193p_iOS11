//
//  CardButton.swift
//  Set
//
//  Created by Ruben on 12/7/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import UIKit

///
/// Represents a UI card button/view to play a Set game
///
/// *** Note **************
/// Implementation for this class is not good and lacks comments since the next
/// assignment we'll be replacing it for a good design with custom views.
/// ***********************
///
class CardButton: UIButton {
    
    var card: Card? {
        didSet {
            if card == nil {
                isHidden = true
                setAttributedTitle(NSAttributedString(), for: .normal)
            }
            else {
                setAttributedTitle(titleForCard(card!), for: .normal)
                isHidden = false
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }

    private func initialSetup() {
        layer.cornerRadius = frame.width * 0.2
        layer.borderColor = UIColor.lightGray.cgColor
        isHidden = true // shown until card is set
    }
    
    func toggleCardSelection() {
        cardIsSelected = !cardIsSelected
    }
    
    var cardIsSelected: Bool {
        get {
            return layer.borderColor == #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        set {
            if newValue == true {
                layer.borderWidth = 3.0
                layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }
            else {
                layer.borderWidth = 0.0
                layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }
        }
    }
    
    private func titleForCard(_ card: Card) -> NSAttributedString {
    
        // Assignment 2 (Task #11):
        // "Instead of drawing the Set cards in the classic form (we’ll do that next week), we’ll
        // use these three characters ▲ ● ■ and use attributes in NSAttributedString to draw them
        // appropriately. That way your cards can just be UIButtons."
        
        var symbol: String
        
        // SHAPE
        switch card.feature1 {
        case .v1: symbol = "▲"
        case .v2: symbol = "●"
        case .v3: symbol = "■"
        }
        
        var color: UIColor
        
        // COLOR
        switch card.feature2 {
        case .v1: color = #colorLiteral(red: 0.6733523739, green: 0, blue: 0.8106054687, alpha: 1)
        case .v2: color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        case .v3: color = #colorLiteral(red: 0.03970472395, green: 0.8106054687, blue: 0, alpha: 1)
        }
        
        var filled: Bool
        
        // SHADE
        switch card.feature3 {
        // Not filled
        case .v1: filled = false; color = color.withAlphaComponent(1.0)
        // Shaded
        case .v2: filled = true; color = color.withAlphaComponent(0.3)
        // Filled
        case .v3: filled = true; color = color.withAlphaComponent(1.0)
        }
        
        // NUMBER
        switch card.feature4 {
        // One
        case .v1: break
        // Two
        case .v2: symbol += "" + symbol
        // Trhee
        case .v3: symbol += "" + symbol + "" + symbol
        }
        
        let attributes: [NSAttributedStringKey:Any] = [
            NSAttributedStringKey.strokeWidth : 1.0 * (filled ? -1.0 : 5.0),
            NSAttributedStringKey.foregroundColor : color,
        ]
        
        let attributedString = NSAttributedString(string: symbol, attributes: attributes)
        
        return attributedString
    }
}
