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
}
