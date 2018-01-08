//
//  ImageViewController.swift
//  Cassini
//
//  Created by Ruben Baca on 1/6/18.
//  Copyright © 2018 Ruben Baca. All rights reserved.
//
import UIKit

///
/// Controller that displays an image from the given `imageURL`
///
class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    // Model: The URL used to retrieve the image we're going to show
    var imageURL: URL? {
        didSet {
            // Reset the image to nil (to remove the prev. one)
            image = nil
            
            //
            // Only fetch the image if we're on screen, to avoid unnecessary
            // network/resources from being wasted
            //
            if viewControllerIsOnScreen {
                fetchImage()
            }
            // else (we're not on screen, wait until viewDidAppear occurs, and fetch the image there)
        }
    }
    
    ///
    /// Allows to set/get the UIImage shown in the `imageView`. It will also adapt/setup
    /// things to correctly match the controller's state. (i.e. adapt the `scrollView's`
    /// contentSize to properly enclose the new image size)
    ///
    private var image: UIImage? {
        set {
            // Setup imageView's image to the new value
            imageView.image = newValue
            
            // Resize the view to properly fit the image's size
            imageView.sizeToFit()
            
            // Make sure the scrollView's content size encloses the new image size
            scrollView?.contentSize = imageView.frame.size
            
            // We've succesfully set an image, stop the spinner
            spinner?.stopAnimating()
        }
        get {
            // Return the imageView's current image
            return imageView.image
        }
    }
    
    ///
    /// Whether or not the current view controller is shown on screen.
    ///
    private var viewControllerIsOnScreen: Bool {
        // We determine if we're on screen based on whether or not the controller's view
        // has a `window` set.
        return view.window != nil
    }
    
    ///
    /// Handle the fact that the view did appear on screen
    ///
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check if we need to fetch the image
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    ///
    /// UIScrollView where the image is shown
    ///
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            // Setup scrollView (zoom properties and delegation methods)
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            
            // Add the imageView to the scrollView's subviews
            scrollView.addSubview(imageView)
        }
    }
    
    ///
    /// ImageView
    ///
    private var imageView = UIImageView()
    
    ///
    /// Fetch image from `imageURL` and show it in `imageView`
    ///
    private func fetchImage() {
        
        // Note: slightly different approach than shown on the lecture (if-let blocks vs. guard blocks)
        
        // Check that URL is set
        guard let url = imageURL else {
            return // nothing to set
        }
        
        // Start the spinner to indicate we're about to start fetching/downloading the image
        spinner.startAnimating()
        
        //
        // Fetch image in the "background" (non-main queue).
        //
        // Note: Although we don't have a memory cycle for capturing `self`, we are using `[weak self]` because
        // the asynchronous operation could take some time to respond; by that time, the user might not be
        // waiting for it anymore (i.e. hit back or go somewhere else). In this case, we don't want to keep
        // `self` in the heap.
        //
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            // Retrieve image data from the given URL
            guard let imageData = try? Data(contentsOf: url) else {
                return // failed to get data from URL
            }
            
            //
            // Set the image when the prev. async. operation finishes.
            //
            // Note: setting up `image` here is affecting/updating our UI. This must be done in the main
            // queue.
            //
            DispatchQueue.main.async {
                
                //
                // Note: This block of code might occur N seconds/minutes after we went fetching the data
                // to the network. Because of this, the controller's `imageURL` might not be the same anymore
                // (i.e. the caller/user changed it to something else), so we are checking that the url is
                // still the same and therefore, the image is the one we currently want to show.
                //
                if url == self?.imageURL {
                    self?.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    ///
    /// View did load
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For now, if imageURL is not set, load a default one
        if imageURL == nil {
            imageURL = DemoURLs.stanford
        }
    }
    
    ///
    /// Which view should be affected by the scrollView's zoom actions
    ///
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    ///
    /// Activity indicator (spinner) that shows when loading an image.
    /// This tells the user that the image is being fetched.
    ///
    @IBOutlet weak var spinner: UIActivityIndicatorView!
}
