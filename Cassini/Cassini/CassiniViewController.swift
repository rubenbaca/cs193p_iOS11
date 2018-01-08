//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Ruben Baca on 1/7/18.
//  Copyright © 2018 Ruben Baca. All rights reserved.
//
import UIKit

///
/// Controller that allows user to select a Cassini image.
///
class CassiniViewController: UIViewController {

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little
    // preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // We prepare the image based on the segue's identifier
        guard let identifier = segue.identifier else {
            return // expected a valid identifier
        }
        
        // Destination must be an ImageViewController
        guard let imageViewController = segue.destination.contents as? ImageViewController else {
            return // expected a segue to ImageViewController class
        }
        
        // Setup destination's model (URL) and title
        imageViewController.imageURL = DemoURLs.NASA[identifier]
        imageViewController.title = (sender as? UIButton)?.currentTitle ?? "?"
    }

}

///
/// Simple but useful utilities for `UIViewController`
///
extension UIViewController {
    
    ///
    /// The contents of the controller. It is `self` in all cases except for instances of
    /// `UINavigationController` where, if present, returns the controller's visible view
    /// controller (or self if none is set).
    ///
    /// This allows for great iphone/ipad compatibillity
    /// in just one UI.
    ///
    var contents: UIViewController {
        
        // Is this a navigation controller?
        if let navigationVC = self as? UINavigationController {
            return navigationVC.visibleViewController ?? self
        }
        else {
            return self
        }
        
        // TODO: this could work great with UITabViewController
    }
}
