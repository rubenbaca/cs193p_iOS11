//
//  Document.swift
//  ImageGallery_P6
//
//  Created by Ruben on 3/16/18.
//  Copyright © 2018 Ruben. All rights reserved.
//
import UIKit

///
/// UIDocument that represents an ImageGallery
///
class ImageGalleryDocument: UIDocument {
    
    ///
    /// The image gallery for the document
    ///
    var gallery: ImageGallery?
    
    ///
    /// A thumbnail image representing the document. I.e. shown in Finder, as the document's icon
    ///
    var thumbnail: UIImage?
    
    //
    // Override this method to return the document data to be saved.
    //
    override func contents(forType typeName: String) throws -> Any {
        // Note: this method returns `Any` in case you need to return a FileWrapper. For regular
        // documents, returning `Data` is the way to go. Here, we'll return a JSON/Data representation
        // of the `ImageGallery`
        return try! JSONEncoder().encode(gallery)
    }
    
    //
    // Override this method to load the document data into the app’s data model.
    //
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // We only support loading `Data`, which should be a JSON representation of an `ImageGallery`
        guard let data = contents as? Data else {
            // The thing we want to load is not valid Data
            throw ImageGalleryDocumentError.dataProblem
        }
        
        // Try to decode the Data as JSON, otherwise, error will be thrown to the caller
        gallery = try JSONDecoder().decode(ImageGallery.self, from: data)
    }
    
    //
    // Called or overridden to handle an error that occurs during an attempt to read, save, or
    // revert a document.
    //
    override func handleError(_ error: Error, userInteractionPermitted: Bool) {
        // TODO: here we would handle any errors thrown
        print("--- ERROR: \(error)")
    }
    
    //
    // Returns a dictionary of file attributes to associate with the document file when writing
    // or updating it.
    //
    // We're overriding this to add a custom thumbnail image that represents our document.
    //
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocumentSaveOperation) throws -> [AnyHashable : Any] {
        
        // Get all attributes for the document, so we can add a thumbnail image
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        
        // If we have a vaild thumbnail set, use it
        if let thumbnail = self.thumbnail {
            // Add our ustom thumbnail image
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey:thumbnail]
        }
        return attributes
    }
}

///
/// Possible errors for ImageGalleryDocument operations
///
enum ImageGalleryDocumentError: Error {
    ///
    /// Data problem. (i.e. we were asked to open a document with invalid Data)
    ///
    case dataProblem
    
    ///
    /// Problem decoding the data. (i.e. we got a corrupt/invalid JSON representation)
    ///
    case decodingProblem(String)
}
