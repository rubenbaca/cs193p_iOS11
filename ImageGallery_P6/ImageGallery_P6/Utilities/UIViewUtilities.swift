//
//  UIViewUtilities.swift
//  ImageGallery_P6
//
//  Created by Ruben on 3/17/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import UIKit

extension UIView {
    var snapshot: UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
