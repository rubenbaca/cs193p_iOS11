//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Ruben on 1/12/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import UIKit

///
/// View for EmojiArt. Contains/shows the given image.
///
class EmojiArtView: UIView {
    
    ///
    /// The background image
    ///
    var backgroundImage: UIImage? {
        didSet {
            // When image is set, we need to re-draw ourselves
            setNeedsDisplay()
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Set backgroundImage as the background
        backgroundImage?.draw(in: bounds)
    }
    
    // Init with frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // Init with coder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    ///
    /// Do initialization setup. Called after init(frame:) and init(coder:)
    ///
    private func setup() {
        // Register `self` to accept drop interactions
        addInteraction(UIDropInteraction(delegate: self))
    }
    
    ///
    /// Add UILabel with the given `attributedString` and centered at `centerPoint`
    ///
    private func addLabel(with attributedString: NSAttributedString, centeredAt centerPoint: CGPoint) {
        let label = UILabel()
        
        // Setup label's color, text, size, etc.
        label.backgroundColor = .clear
        label.attributedText = attributedString
        label.sizeToFit()
        label.center = centerPoint
        
        // Add gesture recognizers to the label (i.e. pan to move, pinch to zoom, etc.)
        addEmojiArtGestureRecognizers(to: label)
        
        // Add subview
        self.addSubview(label)
    }
}

//
// Make `EmojiArtView` conform to `UIDropInteractionDelegate`
//
extension EmojiArtView: UIDropInteractionDelegate {
    
    //
    // What to do when performing a drop
    //
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        // Copy item(s)
        return UIDropProposal(operation: .copy)
    }
    
    //
    // Determine if we can accept the given drop/session
    //
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    //
    // Perform the given drop
    //
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        // Process any dropped attributed strings
        session.loadObjects(ofClass: NSAttributedString.self) { providers in
            
            // The location where the drop happens. Used to drop label in correct place
            let dropPoint = session.location(in: self)
            
            // Process each dropped attributed string
            for attributedString in providers as? [NSAttributedString] ?? [] {
                // Add a label with the dropped string
                self.addLabel(with: attributedString, centeredAt: dropPoint)
            }
        }
    }
}
