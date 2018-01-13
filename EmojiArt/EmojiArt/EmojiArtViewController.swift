//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Ruben on 1/12/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import UIKit

///
/// TODO: fill this header. So far, the controller allows the user to drag and drop an
/// image/url set into it. It will then show the image on screen.
///
class EmojiArtViewController: UIViewController, UIDropInteractionDelegate {

    ///
    /// View that handles the drop interaction(s)
    ///
    @IBOutlet weak var dropZone: UIView! {
        didSet {
            // Set `self` as the delegate for drop interactions
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    ///
    /// Return whether the delegate is interested in the given session
    ///
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        // Drag must be URL and UIImage. (Using NSURL because this is an objective-c api. Although we
        // have automatic-bridging between objective-c's NSURL and swift's URL, we must use NSURL.self
        // because we're passing the specific class to `canLoadObjects`)
        return session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: NSURL.self)
    }
    
    ///
    /// Tells the delegate the drop session has changed.
    ///
    /// You must implement this method if the drop interaction’s view can accept drop activities. If
    /// you don’t provide this method, the view cannot accept any drop activities.
    ///
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        // Copy whatever is being dropped into the view
        return UIDropProposal(operation: .copy)
    }
    
    ///
    /// Tells the delegate it can request the item provider data from the session’s drag items.
    ///
    /// You can request a drag item's itemProvider data within the scope of this method only and
    /// not at any other time.
    ///
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        // Image fetcher allows to fetch an image in the background based on given URL
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.emojiArtView.backgroundImage = image
            }
        }
        
        // Process the array of URL's
        session.loadObjects(ofClass: NSURL.self) { nsurls in
            // We only care about the first one. If there were others, ignore them.
            if let url = nsurls.first as? URL {
                // Asynchronously fetch the image based on the given url.
                self.imageFetcher.fetch(url)
            }
        }
        
        // Process the array of images
        session.loadObjects(ofClass: UIImage.self) { images in
            // We only care about the first one. If there were others, ignore them.
            if let image = images.first as? UIImage {
                // Set the image as the fetcher's backup
                self.imageFetcher.backup = image
            }
        }
    }
    
    ///
    /// UIView for creating awesome emoji-art
    ///
    @IBOutlet weak var emojiArtView: EmojiArtView!
    
    ///
    /// Helper class for fetching images from the network in an async. way
    ///
    private var imageFetcher: ImageFetcher!
}
