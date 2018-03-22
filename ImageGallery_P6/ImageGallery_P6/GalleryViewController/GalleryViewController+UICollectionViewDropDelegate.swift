//
//  GalleryViewController+UICollectionViewDropDelegate.swift
//  ImageGallery
//
//  Created by Ruben on 1/20/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import UIKit

//
// Adopt protocol `UICollectionViewDropDelegate`:
//
// "The interface for handling drops in a collection view."
//
extension GalleryViewController: UICollectionViewDropDelegate {
    
    //
    // If NO is returned no further delegate methods will be called for this drop session.
    // If not implemented, a default value of YES is assumed.
    //
    public func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        
        // For external drops, a URL and and Image must be provided
        if session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self) {
            return true
        }
        
        // We want to also accept local drops (using the drag item's localObject property)
        if session.localDragSession?.localContext as? UICollectionView == collectionView {
            return true
        }
        
        // Other(s) are not accepted
        return false
    }
    
    
    //
    // Called frequently while the drop session being tracked inside the collection view's coordinate space.
    // When the drop is at the end of a section, the destination index path passed will be for a item that does not yet exist (equal
    // to the number of items in that section), where an inserted item would append to the end of the section.
    // The destination index path may be nil in some circumstances (e.g. when dragging over empty space where there are no cells).
    // Note that in some cases your proposal may not be allowed and the system will enforce a different proposal.
    // You may perform your own hit testing via -[UIDropSession locationInView]
    //
    public func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        // Determine whether or not the drag session is local (coming from within the collectionView)
        let isLocalDrag = session.localDragSession?.localContext as? UICollectionView == collectionView
        
        // Move local drags, copy external ones
        return UICollectionViewDropProposal(operation: (isLocalDrag ? .move : .copy), intent: .insertAtDestinationIndexPath)
    }
    
    //
    // Called when the user initiates the drop.
    // Use the dropCoordinator to specify how you wish to animate the dropSession's items into their final position as
    // well as update the collection view's data source with data retrieved from the dropped items.
    // If the supplied method does nothing, default drop animations will be supplied and the collection view will
    // revert back to its initial pre-drop session state.
    //
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        // Get the destion index path, if there's none set, just insert at the beginning
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        // Process all items being dragged
        for item in coordinator.items {
            
            // Local drop
            if let sourceIndexPath = item.sourceIndexPath {
                
                // Local drops must have a localObject of `ImageGallery.Item`
                guard let galleryItem = item.dragItem.localObject as? ImageGallery.Item else { break }
                
                // Perform the local drop
                collectionView.performBatchUpdates({
                    // Update model
                    gallery.items.remove(at: sourceIndexPath.item)
                    gallery.items.insert(galleryItem, at: destinationIndexPath.item)
                    
                    // Update view
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                    
                    // Tell controller that the document just changed
                    self.documentChanged()
                })
                
                // This drop will animate the item to the specified index path in the collection view.
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath) // TODO: check this
            }
            // Not a local drop
            else {
                // External drops must provide url and an image that we'll use to get an aspect-ratio
                var url: URL?
                var ratio: ImageGallery.AspectRatio?
                
                // Get the UIImage
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                    // Is this a valid UIImage?
                    if let image = provider as? UIImage {
                        // Get the aspect ratio of the image
                        ratio = ImageGallery.AspectRatio(width: Int(image.size.width), height: Int(image.size.height))
                    }
                }
                
                // Get the URL
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { [weak self] (provider, error) in
                    
                    // Make sure we have a valid URL
                    url = provider as? URL
                    
                    // If both url and ratio were provided, perform the actual drop
                    if url != nil && ratio != nil {
                        
                        // UI is updated in the main queue
                        DispatchQueue.main.async {
                            
                            // Update in batch
                            collectionView.performBatchUpdates({
                                // Update model
                                self?.gallery.items.insert(ImageGallery.Item(imageURL: url!, ratio: ratio!), at: destinationIndexPath.item)
                                
                                // Update view
                                collectionView.insertItems(at: [destinationIndexPath])
                                
                                // Animates the item to the specified index path in the collection view.
                                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath) // TODO: check this

                                // Tell controller that the document just changed
                                self?.documentChanged()
                            })
                        }
                    }
                }
            }
        }
    }
}
