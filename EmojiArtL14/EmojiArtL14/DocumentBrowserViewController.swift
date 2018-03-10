//
//  DocumentBrowserViewController.swift
//  EmojiArtL14
//
//  Created by Ruben on 3/9/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import UIKit

///
/// A view controller for browsing and performing actions on documents stored locally and in the cloud.
///
class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    //
    // View did load
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIDocumentBrowserViewControllerDelegate
        delegate = self
        
        // This will change to true if we're on iPad
        allowsDocumentCreation = false
        
        // We can only open one document at a time
        allowsPickingMultipleItems = false
        
        // If necessary, setup a "template" document used for creating new documents
        setupTemplate()
        
        // Only allow document creation if we got a valid template
        if template != nil {
            // Allow creation only if we have a valid template file
            allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: Data())
        }
    }
    
    ///
    /// If necessary, setup a "template" document used for creating new documents.
    ///
    private func setupTemplate() {
        // Templates are only setup on iPad (we only create documents on iPad because iPhones cannot drag n' drop from outside
        // our app)
        if UIDevice.current.userInterfaceIdiom == .pad {
            template = try? FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
                .appendingPathComponent("Untitled.json")
        }
    }
    
    ///
    /// A URL where the "template/blank" document is stored. Used for creating new documents.
    ///
    private var template: URL?
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        importHandler(template, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        
        // Used to instansiate a new MVC
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        // Note: this "DocumentMVC" identifier is setup in Interface Builder
        // (click MVC -> Identity inspector -> Storyboard ID)
        let documentVC = storyBoard.instantiateViewController(withIdentifier: "DocumentMVC")
        
        // Setup destination's view controller model
        if let emojiArtVC = documentVC.contents as? EmojiArtViewController {
            emojiArtVC.document = EmojiArtDocument(fileURL: documentURL)
            // Present the document view controller
            present(documentVC, animated: true)
        }        
    }
}

