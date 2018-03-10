//
//  EmojiArtDocument.swift
//  EmojiArtL14
//
//  Created by Ruben on 3/9/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import UIKit

///
/// A `UIDocument` representing an EmojiArt document.
///
class EmojiArtDocument: UIDocument {
    
    // Model: EmojiArt
    var emojiArt: EmojiArt?
    
    // Thumbnail image representing the document (i.e. icon that shows in the Files app)
    var thumbnail: UIImage?
    
    //
    // Override this method to return the document data to be saved.
    // Note: this method returns `Any` in case you want to return a `FileWrapper` instead of `Data`
    //
    override func contents(forType typeName: String) throws -> Any {
        return emojiArt?.json ?? Data()
    }
    
    //
    // Override this method to load the document data into the app’s data model.
    //
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Check if the contents passed to us are actually of type Data
        if let json = contents as? Data {
            emojiArt = EmojiArt(json: json)
        }
        else {
            print("Error trying to load EmojiArtDocument. Content is not JSON data")
        }
    }
    
    //
    // Returns a dictionary of file attributes to associate with the document file when writing
    // or updating it.
    //
    // We're overriding this to add a custom thumbnail image that represents our document.
    //
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocumentSaveOperation) throws -> [AnyHashable : Any] {
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        if let thumbnail = self.thumbnail {
            // Add our ustom thumbnail image
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey:thumbnail]
        }
        return attributes  
    }
}

