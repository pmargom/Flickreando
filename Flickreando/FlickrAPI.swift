//
//  FlickrAPI.swift
//  Flickreando
//
//  Created by Pedro Martin Gomez on 13/4/16.
//  Copyright © 2016 Pedro Martin Gomez. All rights reserved.
//

import Foundation

class FlickrAPI {
    
    private let apikey = "75894c2b842b2b0d3054d2691c66ffc2"
    private let baseURL = "https://api.flickr.com/services/rest/"
    private let methodSearch = "flickr.photos.search"
    private let methodWithNoParams = "flickr.photos.getRecent"
    private let format = "json"
    private let sort = "date-taken-desc"
    
    func apiSearch(stringToFind: String, completion: (([Photo])->Void)!) {
        
        var endPoint = "\(baseURL)?"
        
        if (!stringToFind.isEmpty) {
            endPoint = endPoint.stringByAppendingString("method=\(methodSearch)")
            
            let tagsSearchTerm = stringToFind.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
            //if let escapedSearchTerm = tagsSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.whitespaceCharacterSet()) {
                //endPoint = endPoint.stringByAppendingString("&tags=\(escapedSearchTerm)")
            //}
            endPoint = endPoint.stringByAppendingString("&tags=\(tagsSearchTerm)")
            
        }
        else {
            endPoint = endPoint.stringByAppendingString("method=\(methodWithNoParams)")
        }
        
        endPoint = endPoint.stringByAppendingString("&api_key=\(apikey)&format=\(format)&nojsoncallback=1")
        
        let session = NSURLSession.sharedSession()
        
        let apiUrl = NSURL(string: endPoint)
        
        let task = session.dataTaskWithURL(apiUrl!) { (data, response, error) in
            
            if error != nil {
                print(error?.localizedDescription)
            }
            else {
                
                // try to parse JSON
                do {
                    
                    //if let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? JSONArray {
                    if let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? JSONDictionary {
                        
                        guard let jsonPhotos = jsonData["photos"] as? JSONDictionary, jsonPhotoArray = jsonPhotos["photo"] as? JSONArray
                            else {
                                print("Error during getting the JSON info")
                                return
                        }
                        
                        let photos = decode(photo: jsonPhotoArray)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(photos)
                        })
                    }
                    
                }catch{
                    // Error during JSON parsing
                    print("Error during getting the JSON info")
                    
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
}