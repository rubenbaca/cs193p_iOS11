//
//  GalleryViewController+UICollectionViewDataSource.swift
//  ImageGallery
//
//  Created by Ruben on 1/19/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import UIKit

//
// Conform to `UICollectionViewDataSource`
//
extension GalleryViewController: UICollectionViewDataSource {
    
    ///
    /// Number of items in section
    ///
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // How many items does the gallery have?
        return gallery.items.count
    }
    
    ///
    /// Cell for row at indexPath
    ///
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Deque reusable cell for an item's cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Settings.StoryboardIdentifiers.ImageCell, for: indexPath) as! ImageCollectionViewCell
        
        // Setup the cell
        cell.imageURL = gallery.items[indexPath.item].imageURL
        
        // Return it
        return cell
    }
}
