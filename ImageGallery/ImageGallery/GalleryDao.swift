//
//  Database.swift
//  ImageGallery
//
//  Created by Ruben on 1/27/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import Foundation

///
/// A very ugly "data access object" to interact with the data layer of the app,
/// currently some local non-persistent storage.
///
/// This is (obviously) a temporary implementation
///
class Database {
    
    // PUBLIC API
    
    ///
    /// List of documents/galleries
    ///
    static var documents: [[ImageGallery]] = [
        regularDocuments,
        deletedDocuments,
    ]
    
    ///
    /// Delte the given document from the "database"
    ///
    @discardableResult
    static func deleteDocument(section: Int, row: Int) -> ImageGallery? {
        return documents[section].remove(at: row)
    }
    
    ///
    /// Insert the given item into the "database"
    ///
    static func insert(_ newItem: ImageGallery, section: Int, row: Int) {
        documents[section].insert(newItem, at: row)
    }
    
    ///
    /// Rename the gallery at the given location
    ///
    static func rename(_ name: String, section: Int, row: Int) {
        documents[section][row].name = name
    }
    
    
    // ----------------
    // PRIVATE IMPL.
    // ----------------

    
    private init() {}
    
    private static var deletedDocuments: [ImageGallery] = [
        ImageGallery(name: "Trash", items: []),
        ImageGallery(name: "Ugly gallery", items: []),
        ImageGallery(name: "Cats doing boring stuff", items: []),
    ]
    
    private static var regularDocuments: [ImageGallery] = [
        
        ImageGallery(name: "Cats doing funny things", items: []),
        ImageGallery(name: "Stanford", items: []),
        ImageGallery(name: "My favorite TV Show", items: []),
        ImageGallery(name: "Generic name #1", items: []),
        ImageGallery(name: "Generic name #2", items: []),


        ImageGallery(name: "Vacation photos", items: [
            ImageGallery.Item(
                imageURL: URL(string: "http://www.grandoasiscancunresort.com/images/gallery/gallery-1.jpg")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "http://cdn-image.travelandleisure.com/sites/default/files/styles/1600x1000/public/local-experts-cancun-best-pools.jpg?itok=AnlK-wK5")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "http://cdn-image.travelandleisure.com/sites/default/files/styles/1600x1000/public/local-experts-cancun-best-views.jpg?itok=SvbhKBMv")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "http://media5.trover.com/T/55d8f50f8e7cb244c7002ec4/fixedw_large_4x.jpg")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "http://barristourista.com/wp-content/uploads/2015/08/Cancun-Resort-WP.jpg")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "http://cdn-image.travelandleisure.com/sites/default/files/styles/1600x1000/public/local-experts-cancun-best-places-to-honeymoon.jpg?itok=NEKXbrzi")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "https://ndturismo.com/wp-content/uploads/2016/12/cancun2-1.jpg")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "https://www.acoest1984.com/wp-content/uploads/2017/04/mexico.jpg")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ]),

        
        ImageGallery(name: "Tesla", items: [
            
            ImageGallery.Item(
                imageURL: URL(string: "https://static.dezeen.com/uploads/2017/07/tesla-model-3-design_dezeen_sq-1.jpg")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "https://pbs.twimg.com/profile_images/934040578446315521/J4QgpCIj.jpg")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "https://shortlist.imgix.net/app/uploads/2016/04/23151506/tesla-just-unveiled-the-most-important-car-in-the-world-5.jpg?w=1200&h=1&fit=max&auto=format%2Ccompress")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "https://i.pinimg.com/originals/52/09/9b/52099bc8c5188882d2fe09f0f809bf17.jpg")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "https://wallpaperscraft.com/image/tesla_model_s_tesla_model_s_white_city_79773_2048x2048.jpg")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "http://www.ewallpapers.eu/sites/default/files/styles/1024x1024/public/tesla-model-x-60863-2329352.jpg?itok=SWri-te2")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "https://wallpaperscraft.com/image/tesla_model_s_tesla_model_s_road_traffic_79774_1024x1024.jpg")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "https://video-images.vice.com/articles/5a5e16a399e3be0d5d879075/lede/1516115841152-models_red_profile-medium.jpeg?crop=0.66650390625xw:1xh;center,center&resize=0:*")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "https://thewarrencentre.org.au/wp-content/uploads/2017/07/prototype-tesla-elon-1000.jpg")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "https://images.axios.com/uq3p373qD_uCYYfoADPQ_PJy9Iw=/1080x1080/smart/2017/12/15/1513306611534.jpg")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "http://www.scheerdetailing.com/wp-content/uploads/2015/07/thumb_IMG_3639_1024.jpg")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            ImageGallery.Item(
                imageURL: URL(string: "http://www.adsoncars.co.nz/wp-content/uploads/2018/01/151D7C31-6315-481A-9812-625B0D71A62D-35846-000045F15A5E5B7D_tmp.jpg")!,
                ratio: ImageGallery.AspectRatio(width: 1, height: 1)),
            
        ]),
    ]
}
