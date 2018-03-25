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
            imageURL = imageURL?.imageURL // checks to see if there is an embedded imgurl reference
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

        //
        // From Apple's documentation:
        // Applications that do not have special caching requirements or constraints should find
        // the default shared cache instance acceptable.
        //
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        // If data is cached, use it
        if let data = cache.cachedResponse(for: request)?.data {
            if let image = UIImage(data: data) {
                state = .ok(image)
                return
            }
        }
        
        // Data is not in local cache, fetch it
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            
            // Make sure we got valid data
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.state = .fetchFailed("Response didn't obtain any data")
                }
                return
            }
            
            // Make sure we got a response
            guard let response = response else {
                DispatchQueue.main.async {
                    self?.state = .fetchFailed("Response is nil")
                }
                return
            }
            
            // Make sure the data obtained is a valid image
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.state = .fetchFailed("Response data is not valid image")
                }
                return
            }
            
            // Add the image we just got to the local cache
            let cachedData = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedData, for: request)
            
            // We're doing an async. operation. Make sure that by this point the URL we obtained
            // is still the one the user wants!
            if request.url == self?.imageURL {
                DispatchQueue.main.async {
                    self?.state = .ok(image)
                }
            }
        }.resume()
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
