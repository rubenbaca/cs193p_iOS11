//
//  ImageGallery.swift
//  ImageGallery
//
//  Created by Ruben on 1/20/18.
//  Copyright © 2018 Ruben. All rights reserved.
//
import Foundation

///
/// Represents a gallery of "images". It does not store images per se,
/// just an URL where the image is retrieved from, as well as the aspect
/// ratio of such image.
///
class ImageGallery: Codable {
    
    ///
    /// Create new gallery with the given `name` and `items`
    ///
    init(name: String, items: [Item]) {
        self.name = name
        self.items = items
    }
    
    ///
    /// Create empty gallery with default name and no items
    ///
    init() {}
    
    ///
    /// Represents an item in the gallery.
    ///
    struct Item: Codable {
        
        ///
        /// URL where the image is to be retrieved
        ///
        var imageURL: URL
        
        ///
        /// The aspect ratio of the image
        ///
        var ratio: AspectRatio
    }
    
    ///
    /// Provides width and height aspect ratio. (i.e. 16:9, 4:3, etc.)
    ///
    struct AspectRatio: Codable {
        ///
        /// Width
        ///
        var width: Int
        
        ///
        /// Height
        ///
        var height: Int
    }
    
    ///
    /// The name of the gallery
    ///
    var name: String = "Untitled"
    
    ///
    /// List of items in the gallery
    ///
    var items = [Item]()
}

