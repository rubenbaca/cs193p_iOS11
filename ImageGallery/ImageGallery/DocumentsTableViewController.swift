//
//  DocumentsTableViewController.swift
//  ImageGallery
//
//  Created by Ruben on 1/20/18.
//  Copyright © 2018 Ruben. All rights reserved.
//
import UIKit

///
/// Controller that allows the user to navigate through the list of documents (galleries),
/// rename them, delete them and/or create new ones.
///
class DocumentsTableViewController: UITableViewController {
    
    ///
    /// User pressed the add ("+") document button
    ///
    @IBAction func AddDocumentPressed(_ sender: Any) {
        newDocumentPrompt()
    }
    
    ///
    /// Types of section the tableView displays
    ///
    private enum Section {
        
        ///
        /// Regular galleries. The ones the user can view and select.
        ///
        case regularDocuments
        
        ///
        /// Deleted galleries. When user swipes to delete a gallery from the
        /// regularDocuments section, it goes into this "deleted" section
        ///
        case deletedDocuments
        
        ///
        /// Unknown section. The provided sectionIndex was not valid.
        ///
        case unknown
        
        ///
        /// Create a `Section` object from the given section index.
        ///
        init(_ sectionIndex: Int) {
            switch sectionIndex {
            case 0: self    = .regularDocuments
            case 1: self    = .deletedDocuments
            default: self   = .unknown
            }
        }
        
        ///
        /// Get the section-index value for the current case
        ///
        var index: Int {
            switch self {
            case .regularDocuments: return 0
            case .deletedDocuments: return 1
            case .unknown: return 2
            }
        }
    }
    
    ///
    /// Get the `ImageGallery` for the given indexPath
    ///
    private func gallery(at indexPath: IndexPath) -> ImageGallery {
        return Database.documents[indexPath.section][indexPath.row]
    }
    
    ///
    /// Get the `Section` for the given indexPath
    ///
    private func section(at indexPath: IndexPath) -> Section {
        return Section(indexPath.section)
    }
    
    ///
    /// Get the `Section` for the given section index
    ///
    private func section(at sectionIndex: Int) -> Section {
        return Section(sectionIndex)
    }
    
    ///
    /// Move gallery from the given `indexPath` into the given `section`
    ///
    private func moveGallery(from indexPath: IndexPath, to section: Section) {
        // Delete from model
        guard let deletedGallery = Database.deleteDocument(section: indexPath.section, row: indexPath.row) else {
            return
        }
        
        // Update view
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        // Insert the deleted gallery into the "deleted" section
        
        // Insert into model
        let insertIndex = IndexPath(row: 0, section: section.index)

        Database.insert(deletedGallery, section: insertIndex.section, row: insertIndex.row)
        
        // Insert into view
        tableView.insertRows(at: [insertIndex], with: .automatic)
        
    }
    
    ///
    /// Delete the gallery at the given `indexPath`
    ///
    private func deleteGallery(at indexPath: IndexPath) {
        // Update model
        Database.deleteDocument(section: indexPath.section, row: indexPath.row)
        // Update view
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

//
// DataSource methods
//
extension DocumentsTableViewController {
    
    ///
    /// Number of sections available
    ///
    override func numberOfSections(in tableView: UITableView) -> Int {
        // How many documents do we have?
        return Database.documents.count
    }
    
    ///
    /// Get cell for the given indexPath
    ///
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Deque cell from given identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: Settings.StoryboardIdentifiers.DocumentCell, for: indexPath)
        
        // Setup cell's name and style
        cell.textLabel?.text = gallery(at: indexPath).name
        cell.selectionStyle = selectionStyle(forRowAt: indexPath)
        
        // Return it
        return cell
    }
    
    ///
    /// Determine the cell's selection-style for the given indexPath. For instance, cells in the "deleted"
    /// section should not be selectable.
    ///
    private func selectionStyle(forRowAt indexPath: IndexPath) -> UITableViewCellSelectionStyle {
        switch section(at: indexPath) {
        
        // Regular documents: allow for selecetion
        case .regularDocuments:
            return .default
        
        // Other(s): not selectable
        case .deletedDocuments,
             .unknown:
            return .none
        }
    }
    
    ///
    /// Number of rows in given section
    ///
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // How many elements the section has?
        return Database.documents[section].count
    }
    
    ///
    /// Get the title for the given section
    ///
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitle(for: self.section(at: section))
    }
    
    ///
    /// Get a header title for the given section
    ///
    private func headerTitle(for section: Section) -> String {
        switch section {
        case .regularDocuments:
            return "My Galleries"
        case .deletedDocuments:
            return "Deleted Galleries"
        case .unknown:
            return "?"
        }
    }
}

//
// SWIPE:
//    - Left: delte
//    - Right: undelete (if gallery is deleted)
//
extension DocumentsTableViewController {
    
    ///
    /// Is the given row editable?
    ///
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // All cells can be edited (i.e. to delete/undelete them)
        return true
    }
    
    ///
    /// Swipe to delete
    ///
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Process a "swipeToDelete" action
            processSwipeToDelete(at: indexPath)
        }
    }
    
    ///
    /// Process a "swipe-to-delete" action. This might be:
    ///    - Move gallery to "deleted" documents, or...
    ///    - Permanently delete the gallery
    ///
    private func processSwipeToDelete(at indexPath: IndexPath) {
        switch section(at: indexPath) {
        
        // Documents in "regular" section are moved to the "deleted" section
        case .regularDocuments:
            moveGallery(from: indexPath, to: .deletedDocuments)
            
        // Documents in "deleted" section are permanently deleted
        case .deletedDocuments:
            deleteGallery(at: indexPath)
            
        // Ignore other(s)
        case .unknown:
            break
        }
    }
    
    ///
    /// Leading swipe (left to right)
    ///
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Determine swipe actions based on indexPath
        return leadingSwipeActionsConfiguration(forRowAt: indexPath)
    }
    
    ///
    /// What to do for leadingSwipe gestures
    ///
    private func leadingSwipeActionsConfiguration(forRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration {
        // Actions vary based on indexPath
        let actions = leadingSwipeActions(at: indexPath)
        return UISwipeActionsConfiguration(actions: actions)

    }
    
    ///
    /// What to do for leadingSwipe gestures based on indexPath
    ///
    private func leadingSwipeActions(at indexPath: IndexPath) -> [UIContextualAction] {
        switch section(at: indexPath) {
            
        // Deleted documents can swipe to "undelete"
        case .deletedDocuments:
            return leadingSwipeToUndeleteActions(at: indexPath)
            
        // Ignore other(s)
        default:
            return []
        }
    }
    
    ///
    /// User swiped to undelete gallery at indexPath
    ///
    private func leadingSwipeToUndeleteActions(at indexPath: IndexPath) -> [UIContextualAction] {
        
        // Setup action
        let undeleteAction = UIContextualAction(style: .normal, title: "Recover") { (action, view, completion) in
            // Move gallery to "regularDocuments" section
            self.moveGallery(from: indexPath, to: .regularDocuments)
            completion(true)
        }
        
        // Configure action
        undeleteAction.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        // Return it
        return [undeleteAction]
    }
}

//
// NAVIGATION
//
extension DocumentsTableViewController {
    
    ///
    /// Determine if segueing is allowed
    ///
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        // Only supported segue (from this controller) is `ShowGallery`
        case Settings.StoryboardSegues.ShowGallery:
            // Determine if the selected cell should be allowed to segue
            let cell = sender as! UITableViewCell
            return shouldShowGallery(for: cell)
        default:
            return false
        }
    }
    
    ///
    /// Whether or not the given `cell` should be allowed to segue
    ///
    private func shouldShowGallery(for cell: UITableViewCell) -> Bool {

        // Make sure there's an indexPath for the given cell
        guard let indexPath = tableView.indexPath(for: cell) else {
            return false
        }
        
        switch section(at: indexPath) {
        // Cells from "regularDocuments" section can segue to show the actual gallery
        case .regularDocuments:
            return true
        // Other(s) (i.e. deleted galleries) cannot segue
        default:
            return false
        }
    }
    
    ///
    /// Prepare for segue
    ///
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // All segues must contain an identifier
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        
        // `ShowGallery`
        case Settings.StoryboardSegues.ShowGallery:
            // Sender must be a table view cell
            let cell = sender as! UITableViewCell
            // Do `ShowGallery` segue for the given cell
            showGallery(segue: segue, cell: cell)
        default:
            break
        }
    }

    ///
    /// Do `ShowGallery` segue for the given cell
    ///
    private func showGallery(segue: UIStoryboardSegue, cell: UITableViewCell) {
        // Make sure there's an indexPath for the given cell
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        // Make sure we're segueing to a `GalleryViewController`
        guard let galleryVC = segue.destination.contents as? GalleryViewController else {
            return
        }
        
        // Setup/prepare the controller
        galleryVC.gallery = gallery(at: indexPath)
    }
}

//
// RENAME galleries
//
extension DocumentsTableViewController {
    
    ///
    /// Handle the tapping of the accessory button. Allows user to rename the gallery.
    ///
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        renameGalleryPrompt(at: indexPath)
    }
    
    ///
    /// Prompt the user for the oportunity to rename the gallery at the given indexPath
    ///
    private func renameGalleryPrompt(at indexPath: IndexPath) {
        
        // A pop-up alert will ask the user for a new name
        let alert = UIAlertController(title: "Rename Gallery", message: nil, preferredStyle: .alert)
        
        // Option #1: After providing a new name, the user can submit/accept the rename action
        let ok = UIAlertAction(title: "Rename", style: .default) { (action) in
            
            // Alert must contain a textField where new name is provided
            let inputTextField = alert.textFields![0]
            
            // Use the newName provided by the user, or default to something else if none is set
            let newName = inputTextField.text ?? "[Unnamed]"
            
            // Rename the gallery
            self.renameGallery(newName: newName, at: indexPath)
        }
        
        // Option #2: Cancel the renaming (does nothing = ignores renaming)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add both actions to our alert
        alert.addAction(ok)
        alert.addAction(cancel)
        
        // Add a textfield to allow the user for input
        alert.addTextField { (textField) in
            textField.placeholder = "New name..."
            textField.autocapitalizationType = .words
        }
        
        // Present the alert
        present(alert, animated: true)
    }
    
    ///
    /// Rename gallery at `indexPath` using the `newName`
    ///
    private func renameGallery(newName: String, at indexPath: IndexPath) {
        Database.rename(newName, section: indexPath.section, row: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}

//
// Create new document
//
extension DocumentsTableViewController {
    
    ///
    /// Prompt the user to create a new document (i.e. provide name)
    ///
    private func newDocumentPrompt() {
        let alert = UIAlertController(title: "New Gallery", message: nil, preferredStyle: .alert)
        
        // Add input textfield to the alert
        alert.addTextField { (textField) in
            // Ask for gallery name
            textField.placeholder = "Name..."
            // Make textfield autocapitalize words
            textField.autocapitalizationType = .words
        }
        
        // Option #1: Ok/accept
        let okAction = UIAlertAction(title: "Create", style: .default) { (action) in
            let inputTextField = alert.textFields![0]
            let newName = inputTextField.text ?? "[Unnamed]"
            self.insertNewDocument(name: newName)
        }
        
        // Option #2: Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add actions and present the alert
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    ///
    /// Insert a new document/gallery at the beginning of the "regularDocuments" section with the given `name`
    ///
    private func insertNewDocument(name: String) {
        
        // Create new gallery with the given name
        let gallery = ImageGallery(name: name, items: [])
        
        // Insert at the beginning of the "regularDocuments" section
        let indexPathInsertion = IndexPath(row: 0, section: Section.regularDocuments.index)
        
        // Update model
        Database.insert(gallery, section: indexPathInsertion.section, row: indexPathInsertion.row)
        
        // Update view
        tableView.insertRows(at: [indexPathInsertion], with: .automatic)
    }
}
