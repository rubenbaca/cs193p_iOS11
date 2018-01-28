//
//  ItemViewController.swift
//  ImageGallery
//
//  Created by Ruben on 1/20/18.
//  Copyright © 2018 Ruben. All rights reserved.
//
import UIKit

///
/// View controller that displays a given `ImageGallery.Item`
///
class ItemViewController: UIViewController {
    
    // TODO: Should properly reflect "fetching" and "failed" states as in ImageCollectionViewCell
    
    // MARK: Public

    ///
    /// The image to display
    ///
    var galleryItem: ImageGallery.Item? {
        didSet {
            if galleryItem != nil {
                fetchImage(galleryItem!.imageURL)
            }
        }
    }
    
    // MARK: Private
    
    ///
    /// Fetch image using given `url`
    ///
    private func fetchImage(_ url: URL) {
        
        // TODO: should show "loading" animation
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: url.imageURL) else {
                // TODO: should reflect "failed" state
                return
            }
            guard let image = UIImage(data: data) else {
                // TODO: should reflect "failed" state
                return
            }
            
            DispatchQueue.main.async {
                self.imageView = UIImageView(image: image)
            }
        }
    }
    
    ///
    /// The imageView to display
    ///
    private var imageView: UIImageView? {
        didSet {
            if imageView != nil {
                // Adapt view to fit image
                imageView!.sizeToFit()
                
                // Add imageView to scrollView
                scrollView.addSubview(imageView!)
                
                // Update scrollView accordingly
                updateScrollView()
            }
            else {
                // Show a blank screen
                scrollView.subviews.forEach { $0.removeFromSuperview() }
            }
        }
    }
    
    ///
    /// Update scrollView to properly fit the image
    ///
    private func updateScrollView() {

        if imageView != nil {
            
            // The size of the image
            let imageSize = imageView?.image?.size ?? CGSize.zero
            
            // Size of the display
            let displaySize = scrollView.bounds.size
            
            // Scrollview content-size must fit the image
            scrollView.contentSize = imageSize
            
            // A scale that will fit the whole image on screen
            let zoomScaleThatFitsWholeImage = min(displaySize.width/imageSize.width,
                                                  displaySize.height/imageSize.height)
            
            scrollView.minimumZoomScale = zoomScaleThatFitsWholeImage
            scrollView.zoomScale = zoomScaleThatFitsWholeImage
            scrollView.maximumZoomScale = 3.0
        }
        
    }
    
    ///
    /// ScrollView showing the image
    ///
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            setupScrollView()
        }
    }
    
    ///
    /// Setup scrollView. Called right after the scrollView is set.
    ///
    private func setupScrollView() {
        scrollView.delegate = self
    }
    
    ///
    /// View did layout subviews
    ///
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Keep scrollView updated to fit the new bounds
        updateScrollView()
    }
    
}
