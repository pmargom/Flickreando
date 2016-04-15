//
//  PhotoDetailsViewController.swift
//  Flickreando
//
//  Created by Pedro Martin Gomez on 15/4/16.
//  Copyright © 2016 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {


    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var ImageView: UIImageView!
    var photo: Photo?
    var pageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    func updateUI() {
        
        self.navBar.title = photo?.title
        let closeAction = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "closeAction")
        self.navBar.rightBarButtonItem = closeAction
        
        if (photo?.largeImage != nil) {
            
            self.ImageView?.image = UIImage(data: (photo?.largeImage)!)
        }
        else {
            checkConection()
            loadImage(photo!, imageView: ImageView)
        }
        
        
    }
    
    func closeAction() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
