//
//  Photo.swift
//  Flickreando
//
//  Created by Pedro Martin Gomez on 13/4/16.
//  Copyright © 2016 Pedro Martin Gomez. All rights reserved.
//

import Foundation

class Photo {
    
    let id: String?
    let owner: String?
    let secret: String?
    let server: String?
    let farm: Int?
    let title: String?
    let urlSmallPhotoString: String?
    let urlLargePhotoString: String?
    
    var urlSmallPhoto: NSURL?
    var urlLargePhoto: NSURL?
    var smallImage: NSData?
    var largeImage: NSData?
    
    init(id: String?, owner: String?, secret: String?, server: String?, farm: Int?, title: String?, urlSmallPhotoString: String?, urlLargePhotoString: String?, urlSmallPhoto: NSURL?, urlLargePhoto: NSURL?) {
        
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        self.urlSmallPhotoString = urlSmallPhotoString
        self.urlLargePhotoString = urlLargePhotoString
        self.urlSmallPhoto = urlSmallPhoto
        self.urlLargePhoto = urlLargePhoto
        
    }
    
    convenience init(urlSmallPhoto: NSURL, urlLargePhoto: NSURL) {
        
        self.init(id: nil, owner: nil, secret: nil, server: nil, farm: nil, title: nil,  urlSmallPhotoString: nil, urlLargePhotoString: nil, urlSmallPhoto: urlSmallPhoto, urlLargePhoto : urlLargePhoto)
        
    }

}