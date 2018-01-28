//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by Ruben on 1/17/18.
//  Copyright © 2018 Ruben. All rights reserved.
//
import UIKit

///
/// CollectionViewCell that (tries to) display the image from `imageURL`. Fetching the image from the url is done
/// in an asynchronous way, properly showing an activity indicator (spinnign wheel) when the fetching is occuring.
/// If fetching of the image fails (i.e. bad URL, network problems, etc.) a "error" message will be shown.
///
class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: Public interface
    
    ///
    /// This URL should point to a valid image. The cell will (try to) load it and
    /// display the image. If it fails to do so, a warning/indication will be shown.
    ///
    /// The fetching of the image is done asynchronously and, while it downloads, an activity
    /// indicator will be shown.
    ///
    var imageURL: URL? {
        didSet {
            updateUI(for: imageURL)
        }
    }
    
    // MARK: Private implementation

    ///
    /// Updates the cell's UI for the given URL?
    ///
    private func updateUI(for url: URL?) {
        
        // If set to nil, change cell's state to "unset"
        if url == nil {
            state = .unset // changing "state" updates UI accordingly
        }
        else {
            // Fetch the image using the given url
            fetchImage(using: url!)
        }
    }
    
    ///
    /// The state in which the cell is in. Starts as "unset". Changing it updates UI accordingly
    ///
    private(set) var state: State = .unset {
        didSet {
            updateUI(for: state)
        }
    }
    
    ///
    /// Different "states" the cell could be in:
    ///   - Unset: Nothing to display.
    ///   - Fetching: The cell is currently fetching the image asynchronously.
    ///   - FetchFailed(Error): The fetching of the URL failed.
    ///   - Ok(Image): The cell successfully fetched the given url.
    ///
    enum State {
        case unset
        case fetching
        case fetchFailed(String)
        case ok(UIImage)
    }
    
    ///
    /// Fetch image using the given URL
    ///
    private func fetchImage(using url: URL) {
        // Set cell's state to "fetching". (Shows user we're working on it)
        state = .fetching
        
        // Fetch the image without blocking the main queue
        fetchImageAsynchronously(using: url)
    }
    
    ///
    /// Update cell's UI for the given state
    ///
    private func updateUI(for state: State) {
        switch state {
            
        // Not set (i.e. blank cell)
        case .unset:
            unsetState()
            
        // Fetching (i.e. spinning wheel)
        case .fetching:
            fetchingState()
            
        // Ok (successfully fetched the given url)
        case .ok(let image):
            okState(image: image)
            
        // Failed to fetch the image (i.e. network error or bad url)
        case .fetchFailed(let error):
            fetchFailedState(errorMessage: error)
        }
    }
    
    ///
    /// Set cell in the "Unset" state (blank/empty UI)
    ///
    private func unsetState() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    ///
    /// Set cell in the "Fetching" state (show activity indicator)
    ///
    private func fetchingState() {
        subviews.forEach { $0.removeFromSuperview() }
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
        activityIndicator.frame = bounds
        addSubview(activityIndicator)
    }
    
    ///
    /// Set cell in the "Ok/Success" state (show the actual image)
    ///
    private func okState(image: UIImage) {
        subviews.forEach { $0.removeFromSuperview() }
        let imageView = UIImageView(frame: self.bounds)
        imageView.image = image
        addSubview(imageView)
    }
    
    ///
    /// Set cell in the "Fetch-Failed" state (warning message)
    ///
    private func fetchFailedState(errorMessage: String) {
        print("Image fetch failed with error: \(errorMessage)")
        subviews.forEach { $0.removeFromSuperview() }
        let errorLabel = UILabel()
        errorLabel.text = "🚫"
        errorLabel.sizeToFit()
        errorLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        addSubview(errorLabel)
    }

    ///
    /// Fetch the url without blocking the main queue to keep UI responsive.
    ///
    private func fetchImageAsynchronously(using url: URL) {
        
        // Use a high-priority queue that does not block the UI
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            // Fetch data from the given URL
            guard let data = try? Data(contentsOf: url.imageURL) else {
                // Update UI for failed state (in the main queue!)
                DispatchQueue.main.async {
                    self?.state = .fetchFailed("Failed getting data from url: \(url)")
                }
                return
            }
            
            // Create an image with the fetched data
            guard let image = UIImage(data: data) else {
                // Update UI for failed state (in the main queue!)
                DispatchQueue.main.async {
                    self?.state = .fetchFailed("Failed creating image with data from url: \(url)")
                }
                return
            }
            
            // If by the time the async. fetch finishes, the imageURL is still the same (remember it could no
            // longer be the same), update the UI (in the main queue)
            if self?.imageURL == url {
                DispatchQueue.main.async {
                    self?.state = .ok(image)
                }
            }
        }
    }
    
    //
    // Lays out subviews. (i.e. update UI when device rotates)
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update UI when layout changes
        updateUI(for: state)
    }
}
