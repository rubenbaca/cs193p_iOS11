//
//  ItemViewController+UIScrollViewDelegate.swift
//  ImageGallery
//
//  Created by Ruben on 1/21/18.
//  Copyright © 2018 Ruben. All rights reserved.
//
import UIKit

//
// Confrom to `UIScrollViewDelegate`
//
extension ItemViewController: UIScrollViewDelegate {
    
    ///
    /// The view for zooming in the scrollView
    ///
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // If scrollView contains an imageView, return it
        return scrollView.subviews.first as? UIImageView
    }
}
