//
//  GalleryViewController.swift
//  ImageGallery
//
//  Created by Ruben on 1/19/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import UIKit

///
/// Controller that displays an `ImageGallery` inside a collection view.
/// Users are able to click on an item in the gallery and navigate to a new
/// controller showing the item if full detail.
///
class GalleryViewController: UIViewController {
    
    // MARK: Public
    
    ///
    /// The image gallery containing all images (url's) that are to be displayed
    ///
    var gallery = ImageGallery() {
        didSet {
            // When someone sets the gallery, update controller's title to reflect the gallery name
            title = gallery.name
        }
    }
    
    // MARK: Private

    ///
    /// Collection view that displays the image gallery
    ///
    @IBOutlet private weak var collectionView: UICollectionView! { didSet { setupCollectionView() } }
    
    ///
    /// Setup collectionView's delegation/gestures. Called during initial setup.
    ///
    private func setupCollectionView() {
        // Delegation
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dropDelegate = self
        collectionView.dragDelegate = self
        
        // UI Gestures
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchToResize(gesture:)))
        collectionView.addGestureRecognizer(pinchGesture)
    }
    
    ///
    /// Handle pinch gesture recognizer. It will scale the width of the collection view cell's accordingly without
    /// getting too big nor too small.
    ///
    @objc private func pinchToResize(gesture recognizer: UIPinchGestureRecognizer) {
        
        // Process .changed state
        if recognizer.state == .changed {
            
            // Change width and reset scale
            cellWidth *= recognizer.scale
            recognizer.scale = 1.0
            
            // Make sure cellWidth is not too big nor too small
            if cellWidth > collectionView.bounds.size.width {
                // Cap the width to a max. of the collectionView's bound width
                cellWidth = collectionView.bounds.size.width
            }
            else if cellWidth < 80.0 {
                // Minimun width of 80
                cellWidth = 80.0
            }
            
            //
            // invalidateLayout(): Invalidates the current layout and triggers a layout update.
            // You can call this method at any time to update the layout information. This method invalidates the
            // layout of the collection view itself and returns right away. Thus, you can call this method multiple
            // times from the same block of code without triggering multiple layout updates. The actual layout
            // update occurs during the next view layout update cycle.
            //
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    ///
    /// The width of each collectionViewCell
    ///
    private(set) lazy var cellWidth: CGFloat = collectionView.bounds.width / 2.1

    //
    // Subclasses override this method and use it to configure the new view controller prior to it being displayed
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Segue must! contain an identifier. We want to crash if we missed one.
        switch segue.identifier! {
            
        // Show gallery item
        case Settings.StoryboardSegues.ShowItem:
            // Sender must be ImageCollectionViewCell (crash otherwise)
            showItem(for: segue, cell: sender as! ImageCollectionViewCell)
            
        // Other(s): ignore them
        default:
            break
        }
    }
    
    ///
    /// Perform segue that shows the selected gallery item.
    ///
    private func showItem(for segue: UIStoryboardSegue, cell: ImageCollectionViewCell) {
        
        // Destination must! be an ItemViewController
        let itemVC = segue.destination.contents as! ItemViewController

        // Make sure we can retriee an indexPath for the given cell
        guard let indexPath = collectionView.indexPath(for: cell) else {
            print("Couldn't find indexPath for selected cell")
            return
        }
        
        // Setup destination's model.
        itemVC.galleryItem = gallery.items[indexPath.item]
    }
    
}
