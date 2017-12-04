//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Ruben on 12/3/17.
//  Copyright © 2017 Ruben. All rights reserved.
//

import UIKit

///
/// Playing card view that contains a suit and a rank. It can be facing
/// up or down.
///
@IBDesignable
class PlayingCardView: UIView {
    
    /// The cards rank
    @IBInspectable
    var rank: Int = 9 { didSet{ updateView() } }
    
    /// The cards suit
    @IBInspectable
    var suit: String = "♥️" { didSet{ updateView() } }
    
    /// Whether or not the card is facing up
    @IBInspectable
    var isFaceUp: Bool = false { didSet{ updateView() } }
    
    /// The scale of the face card
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet { updateView() } }
    
    ///
    /// Handle pinch to zoom
    ///
    @objc func adjustFaceCardScale(gestureRecognizer: UIPinchGestureRecognizer) {
        switch gestureRecognizer.state {
        case .changed, .ended:
            faceCardScale *= gestureRecognizer.scale
            gestureRecognizer.scale = 1.0 // reset it to get incremental changes only
        default:
            break
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        UIColor.lightGray.setStroke()
        roundedRect.fill()
        roundedRect.stroke()
        
        if isFaceUp {
            // If card has an image, show it (i.e. for Jack/Queen/King)
            if let faceCardImage = namedImage("\(rankString)\(suit)") {
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
            }
                // There is no image, draw the pips
            else {
                drawPips()
            }
        }
        else {
            if let cardBackImage = namedImage("cardback") {
                cardBackImage.draw(in: bounds)
            }
        }
    }
    
    ///
    /// Returns UIImage from the given name (similar to UIImage(named:), but also shows
    /// on Interface Builder)
    ///
    private func namedImage(_ name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection)
    }
    
    ///
    /// Draw pips based on rank and suit
    ///
    private func drawPips()
    {
        let pipsPerRowForRank = [[0], [1], [1,1], [1,1,1], [2,2], [2,1,2], [2,2,2], [2,1,2,2], [2,2,2,2], [2,2,1,2,2], [2,2,2,2,2]]
        
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0)})
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0)})
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize /
                    (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }

    ///
    /// Get an NSAttributedString with the given string and size
    ///
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        // Create font with given size
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        
        // Scale the font to what the user's device has (i.e. Settings>Accessibility>FontSize might be set
        // to prefer bigger/smaller font sizes)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        // Center the font
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        // The attributes to build our string
        let attributes: [NSAttributedStringKey:Any] = [
            .paragraphStyle : paragraphStyle,
            .font : font
        ]
        
        // Create it and return it
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    ///
    /// Returns the string that goes on the card's corner
    ///
    private var cornerString: NSAttributedString {
        return centeredAttributedString("\(rankString)\n\(suit)", fontSize: cornerFontSize)
    }
    
    ///
    /// Updates the view
    ///
    private func updateView() {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    /// The label for the upper-left corner of the card
    private lazy var upperLeftCornerLabel = createCornerLabel()
    
    /// The label for the bottom-right corner of the card
    private lazy var lowerRightCornerLabel = createCornerLabel()
    
    ///
    /// Creates the corner label
    ///
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        
        // Zero means "no-limit"
        label.numberOfLines = 0
        addSubview(label)
        
        return label
    }
    
    /// When bounds change, we want to keep everything positioned correctly
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Configure corner labels
        configureCornerLabel(upperLeftCornerLabel)
        configureCornerLabel(lowerRightCornerLabel)

        // Position corner labels accordingly (using computed vars instead of calculating it here)
        upperLeftCornerLabel.frame.origin = upperLeftCornerLabelOrigin
        lowerRightCornerLabel.frame.origin = lowerRightCornerLabelOrigin
        
        // NOTE: On the lecture, the professor does the transformation first and then sets the label's origin.
        // Because of this, the transformation needs both "translation" and "rotation". We can also set the origin
        // first and then applying a "rotation" only, which I'm doing here.
        
        // We need to rotate the lower-right label
        lowerRightCornerLabel.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)

    }
    
    ///
    /// The origin point for the upper-left corner label
    ///
    private var upperLeftCornerLabelOrigin: CGPoint {
        return bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
    }
    
    ///
    /// The origin point for the lower-right corner label
    ///
    private var lowerRightCornerLabelOrigin: CGPoint {
        return CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.width, dy: -lowerRightCornerLabel.frame.height)
    }
    
    ///
    /// Configure the corner labels text, size, etc.
    ///
    private func configureCornerLabel(_ label: UILabel) {
        // Set the attributed text
        label.attributedText = cornerString
        
        // Set the label's size to fit the content
        label.frame.size = CGSize.zero // reset it's size first
        label.sizeToFit()
        
        // Only show the label when the card is facing-up
        label.isHidden = !isFaceUp
    }
    
    //
    // Called when the iOS interface environment changes.
    //
    // For example, when user changes the system-wide accessibility font size
    //
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection) // NOTE: professor forgot to call super's method
        updateView()
    }
    
}


// Extension with simple but useful utilities
extension PlayingCardView {
    
    /// Ratios that determine the card's size
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.95
    }
    
    /// Corner radius
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    /// Corner offset
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    /// The font size for the corner text
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    /// Get the string-representation of the current rank
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

// Extension with simple but useful utilities
extension CGPoint {
    /// Get a new point with the given offset
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

// Extension with simple but useful utilities
extension CGRect {
    
    /// Zoom rect by given factor
    func zoom(by zoomFactor: CGFloat) -> CGRect {
        let zoomedWidth = size.width * zoomFactor
        let zoomedHeight = size.height * zoomFactor
        let originX = origin.x + (size.width - zoomedWidth) / 2
        let originY = origin.y + (size.height - zoomedHeight) / 2
        return CGRect(origin: CGPoint(x: originX,y: originY) , size: CGSize(width: zoomedWidth, height: zoomedHeight))
    }
    
    /// Get the left half of the rect
    var leftHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: origin, size: CGSize(width: width, height: size.height))
    }
    
    /// Get the right half of the rect
    var rightHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: CGPoint(x: origin.x + width, y: origin.y), size: CGSize(width: width, height: size.height))
    }
}







