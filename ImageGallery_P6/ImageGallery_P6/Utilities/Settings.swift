//
//  Settings.swift
//  ImageGallery
//
//  Created by Ruben on 1/21/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import Foundation

///
/// Settings for the app
///
struct Settings {
    
    ///
    /// Do not allow new instances
    ///
    private init() {}
    
    ///
    /// Contains storyboard segue identifiers
    ///
    struct StoryboardSegues {
        
        ///
        /// Segue that goes from a gallery item cell, to a item detail controller
        ///
        static let ShowItem = "ShowItem"
        
        ///
        /// Segue that shows the selected image gallery
        ///
        static let ShowGallery = "ShowGallery"
    }
    
    ///
    /// Contains storyboard identifiers, such as tableView cell identifiers
    ///
    struct StoryboardIdentifiers {
        ///
        /// CollectionViewCell that shows a gallery image
        ///
        static let ImageCell = "ImageCell"
        
        ///
        /// TableViewCell that shows a gallery document
        ///
        static let DocumentCell = "DocumentCell"
    }
}
