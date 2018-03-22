//
//  DocumentBrowserViewController.swift
//  ImageGallery_P6
//
//  Created by Ruben on 3/16/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import UIKit

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    //
    // View did load
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup view controller
        delegate = self
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    //
    // Asks the delegate to create a new document.
    //
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        
        // To create a new document, we'll use the "Gallery.imgallery" template that ships with the app
        let newDocumentURL: URL = Bundle.main.url(forResource: "Gallery", withExtension: "imgallery")!
        
        // Call handler that imports the document with the given URL
        importHandler(newDocumentURL, .copy)
    }
    
    //
    // Tells the delegate that the user has selected one or more documents.
    //
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        
        // Make sure we have a valid URL (we only support picking one document at a time)
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the document that was picked.
        presentDocument(at: sourceURL)
    }
    
    //
    // Tells the delegate that a document has been successfully imported.
    //
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    //
    // Tells the delegate that the document browser failed to import the specified document.
    //
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // TODO: we should display a message to the user here
        print("==== FAILED")
    }
    
    // MARK: Document Presentation
    
    //
    // Present document for the given url
    //
    func presentDocument(at documentURL: URL) {
        
        // We'll get a view controller from the `Main` storyboard
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        // Our gallery view controller is embedded in a navigation controller
        let navigationVC = storyBoard.instantiateViewController(withIdentifier: "GalleryControllerEntry") as! UINavigationController
        let documentViewController = navigationVC.contents as! GalleryViewController

        // Setup/prepare VC before presenting it
        documentViewController.document = ImageGalleryDocument(fileURL: documentURL)
        
        // Present the navigation VC to the user
        present(navigationVC, animated: true, completion: nil)
    }
}

