//
//  Utils.swift
//  Flickreando
//
//  Created by Pedro Martin Gomez on 15/4/16.
//  Copyright © 2016 Pedro Martin Gomez. All rights reserved.
//

import SystemConfiguration
import UIKit

func loadImage(photo: Photo, imageView: UIImageView) -> Void {
    
    guard let url = NSURL(string: photo.urlLargePhotoString!) else {
        return
    }
    
    let request = NSMutableURLRequest(URL: url)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
        
        guard data != nil else {
            return
        }
        
        photo.largeImage = data!
        let image = UIImage(data: data!)
        
        dispatch_async(dispatch_get_main_queue(), {
            
            imageView.image = image
            imageView.fadeOut(duration: 0.0)
            imageView.fadeIn()
            
        })
    }
    
    task.resume()
    
}

func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
        SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
    }
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
}


func showAlert(message: String) {
    
    let alert = UIAlertView()
    alert.title = "Alert"
    alert.message = message
    alert.addButtonWithTitle("OK")
    alert.show()
}

func checkConection() {
    if (!isConnectedToNetwork()) {
        showAlert("No internet conection")
        return
    }
}

public extension UIImageView {
    
    func fadeIn(duration duration: NSTimeInterval = 1.0) {
        UIImageView.animateWithDuration(duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(duration duration: NSTimeInterval = 1.0) {
        UIImageView.animateWithDuration(duration, animations: {
            self.alpha = 0.0
        })
    }
    
}
