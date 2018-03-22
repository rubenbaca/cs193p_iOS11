//
//  GalleryViewController+UICollectionViewDragDelegate.swift
//  ImageGallery
//
//  Created by Ruben on 1/20/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import UIKit

//
// Adopt `UICollectionViewDragDelegate`:
//
// "The interface for initiating drags from a collection view."
//
extension GalleryViewController: UICollectionViewDragDelegate {
    
    //
    // Provide items to begin a drag associated with a given indexPath.
    // If an empty array is returned a drag session will not begin.
    //
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        // Set local context to the collectionView
        session.localContext = collectionView
        
        // The item being dragged
        let item = gallery.items[indexPath.item]
        
        // For drags outside our app, the URL of the image will be provided
        let url = UIDragItem(itemProvider: NSItemProvider(object: item.imageURL as NSURL))
        
        // For local drags, the full `ImageGallery.Item` will be provided
        url.localObject = item
        
        return [url]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        // Set local context to the collectionView
        session.localContext = collectionView
        
        // The item being dragged
        let item = gallery.items[indexPath.item]
        
        // For drags outside our app, the URL of the image will be provided
        let url = UIDragItem(itemProvider: NSItemProvider(object: item.imageURL as NSURL))
        
        // For local drags, the full `ImageGallery.Item` will be provided
        url.localObject = item
        
        return [url]
    }
}
