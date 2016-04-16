//
//  PhotoPageViewController.swift
//  Flickreando
//
//  Created by Pedro Martin Gomez on 15/4/16.
//  Copyright © 2016 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class PhotoPageViewController: UIPageViewController {

    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
