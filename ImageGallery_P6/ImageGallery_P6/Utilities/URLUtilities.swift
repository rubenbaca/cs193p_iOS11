//
//  URLUtilities.swift
//  ImageGallery
//
//  Created by Ruben on 1/20/18.
//  Copyright © 2018 Ruben. All rights reserved.
//
import Foundation

///
/// Simple but useful utilities for `URL`
///
extension URL {
    var imageURL: URL {
        // check to see if there is an embedded imgurl reference
        for query in query?.components(separatedBy: "&") ?? [] {
            let queryComponents = query.components(separatedBy: "=")
            if queryComponents.count == 2 {
                if queryComponents[0] == "imgurl", let url = URL(string: queryComponents[1].removingPercentEncoding ?? "") {
                    return url
                }
            }
        }
        return self.baseURL ?? self
    }
}
