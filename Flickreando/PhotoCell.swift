//
//  PhotoCell.swift
//  Flickreando
//
//  Created by Pedro Martin Gomez on 15/4/16.
//  Copyright © 2016 Pedro Martin Gomez. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class PhotoCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var blurViewFrame : CGRect!
    
    override func awakeFromNib() {
        
        titleLabel.font = UIFont(name: DefaultTheme.fontName, size: 14)
        titleLabel.textColor = UIColor.blackColor()        
        layer.borderColor = UIColor(white: 0.9, alpha: 1.0).CGColor
        layer.borderWidth = 0.3
    }
    
}