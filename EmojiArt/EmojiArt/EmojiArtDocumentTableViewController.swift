//
//  EmojiArtDocumentTableViewController.swift
//  EmojiArt
//
//  Created by Ruben on 1/12/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import UIKit

///
/// Controller for handling emoji-art documents
///
class EmojiArtDocumentTableViewController: UITableViewController {
    
    // MARK: Model - List of documents represented as strings
    var emojiArtDocuments = ["One", "Two", "Three"]

    // MARK: - Table view data source

    ///
    /// Number of sections in the table view
    ///
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    ///
    /// Number of rows in the table view
    ///
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // One row for each element in the emojiArtDocuments array
        return emojiArtDocuments.count
    }

    ///
    /// Get the tableView cell for the given indexPath
    ///
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reusable cell to populate
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        
        // Setup the cell's content
        cell.textLabel?.text = emojiArtDocuments[indexPath.row]

        // Return the cell
        return cell
    }
    
    
    ///
    /// Override to support conditional editing of the table view. (i.e. swipe to delete)
    ///
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    ///
    /// Override to support editing the table view.
    ///
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Delete
        if editingStyle == .delete {
            // Update model (delete record)
            emojiArtDocuments.remove(at: indexPath.row)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    ///
    /// Add a new document with an auto-generated name
    ///
    @IBAction func newEmojiArt(_ sender: UIBarButtonItem) {
        // Add a new document to the model (with auto-generated name)
        emojiArtDocuments.append("Document".madeUnique(withRespectTo: emojiArtDocuments))
        
        // Reload tableView
        tableView.reloadData()
    }
    
    //
    // Called to notify the view controller that its view is about to layout its subviews.
    //
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Make sure the split-view controller's diplay mode is the one we want.
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            // The primary view controller is layered on top of the secondary view controller,
            // leaving the secondary view controller partially visible.
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
}
