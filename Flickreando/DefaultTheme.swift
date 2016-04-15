//
//  DefaultTheme.swift
//  Flickreando
//
//  Created by Pedro Martin Gomez on 15/4/16.
//  Copyright © 2016 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class DefaultTheme {
    
    class var fontName : String {
        return "Avenir-Book"
    }
    
    class var boldFontName : String {
        return "Avenir-Black"
    }
    
    class var lighterFontName : String {
        return "Avenir-Light"
    }
    
    class var darkColor : UIColor {
        //return UIColor.blackColor()
        return UIColor.whiteColor()
    }
    
    class var lightColor : UIColor {
        return UIColor(white: 0.6, alpha: 1.0)
    }
}