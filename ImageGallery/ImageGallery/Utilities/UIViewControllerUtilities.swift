//
//  UIViewControllerUtilities.swift
//  ImageGallery
//
//  Created by Ruben on 1/26/18.
//  Copyright © 2018 Ruben. All rights reserved.
//
import UIKit

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
