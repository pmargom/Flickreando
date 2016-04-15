//
//  JSONHelper.swift
//  Flickreando
//
//  Created by Pedro Martin Gomez on 13/4/16.
//  Copyright © 2016 Pedro Martin Gomez. All rights reserved.
//

import Foundation

//MARK: - KEYS

enum JSONKeys: String {
    case id = "id"
    case owner = "owner"
    case secret = "secret"
    case server = "server"
    case farm = "farm"
    case title = "title"
}

//MARK: - ALIASES

typealias JSONObject        = AnyObject
typealias JSONDictionary    = [String:JSONObject]
typealias JSONArray         = [JSONDictionary]

//MARK: - ERRORS

enum JSONError : ErrorType {
    case WrongURLFormatForJSONResource
    case ResourcePointedByURLNotReachable
    case JSONParsingError
    case WrongJSONFormat
}

// MARK: Image sizes
enum PhotoSize: String {
    case Small = "_s"
    case Medium = "_m"
    case Large = ""
}

let PLACE_HOLDER_IMAGE = "placesHolderImage.png"
let PLACE_HOLDER_IMAGE_SMALL = "placesHolderImageSmall.png"

// MARK: JSON util methods

func decode(photo json:JSONDictionary) throws -> Photo {
    
    let id = getStringFromJSON(json, key: JSONKeys.id.rawValue)
    let owner = getStringFromJSON(json, key: JSONKeys.owner.rawValue)
    let secret = getStringFromJSON(json, key: JSONKeys.secret.rawValue)
    let server = getStringFromJSON(json, key: JSONKeys.server.rawValue)
    let farm = getIntFromJSON(json, key: JSONKeys.farm.rawValue)
    let title = getStringFromJSON(json, key: JSONKeys.title.rawValue)
    
    let urlSmallPhotoString = buildImageUrl(id, secret: secret, server: server, farm: farm, size: PhotoSize.Small.rawValue)
    let urlLargePhotoString = buildImageUrl(id, secret: secret, server: server, farm: farm, size: PhotoSize.Large.rawValue)
    
    guard let urlSmallPhoto = NSURL(string: urlSmallPhotoString),
        urlLargePhoto = NSURL(string: urlLargePhotoString)
        else {
            throw JSONError.ResourcePointedByURLNotReachable
    }
    
    // everything seems to be ok
    return Photo(id: id, owner: owner, secret: secret, server: server, farm: farm, title: title, urlSmallPhotoString: urlSmallPhotoString, urlLargePhotoString: urlLargePhotoString, urlSmallPhoto: urlSmallPhoto, urlLargePhoto: urlLargePhoto)
    
}

func decode(photo json: JSONArray) -> [Photo] {
    
    var results = [Photo]()
    
    do {
        for dict in json {
            
            let item = try decode(photo: dict)
            
            results.append(item)
            
        }
        
    } catch {
        fatalError("Error during parsing json array")
    }
    
    return results
    
    
}

func getStringFromJSON(data: JSONDictionary, key: String) -> String {
    
    guard let value = data[key] as? String else {
        
        return ""
        
    }
    
    return value
}

func getIntFromJSON(data: JSONDictionary, key: String) -> Int {
    
    guard let value = data[key] as? Int else {
        
        return -1
        
    }
    
    return value
}

// MARK: URL builing method

// http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret)_\(size).jpg
// http://farm2.static.flickr.com/1548/25800985434_106560b6a1.jpg
func buildImageUrl(id: String?, secret: String?, server: String?, farm: Int?, size: String?) -> String {
    
    //return "http://farm2.static.flickr.com/1509/26142827610_5fc2e1f260_s.jpg"
    return String(format: "http://farm%d.static.flickr.com/%@/%@_%@%@.jpg", farm!, server!, id!, secret!, size!)
}














