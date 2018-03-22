//
//  GalleryViewController+UICollectionViewDelegateFlowLayout.swift
//  ImageGallery
//
//  Created by Ruben on 1/19/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import UIKit

//
// Adpot protocol UICollectionViewDelegateFlowLayout:
//
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    //
    // Asks the delegate for the size of the specified item’s cell.
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Get aspect ratio of the image to display
        let ratio = gallery.items[indexPath.item].ratio
                
        // Height is calculated based on the width and aspect ratio
        let height: CGFloat = (cellWidth * CGFloat(ratio.height)) / CGFloat(ratio.width)
        
        // The cell's size
        return CGSize(width: cellWidth, height: height)
    }
}
