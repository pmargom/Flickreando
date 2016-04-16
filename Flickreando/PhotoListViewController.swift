//
//  PhotoListViewController.swift
//  Flickreando
//
//  Created by Pedro Martin Gomez on 13/4/16.
//  Copyright © 2016 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class PhotoListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UIPageViewControllerDataSource {

    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let CellId = "PhotoCellId"
    private let cellHeight : CGFloat = 200
    private var photos: [Photo]?
    private let api = FlickrAPI()
    
    private var photoPageViewController: PhotoPageViewController?

    
    // MARK: View Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCustomCell()
        photos = [Photo]()
        
        loadDataFromApi("")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: Setup UI
    
    func setupUI() -> Void {
        
        self.navBar.title = "Flickreando"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let cellWidth = calcCellWidth(self.view.frame.size)
        layout.itemSize = CGSizeMake(cellWidth, cellHeight)
    }
    
    // MARK: Cell registration
    
    func registerCustomCell() -> Void {
        
        let nibPhotoCellView = UINib(nibName: "PhotoCellView", bundle: nil)
        self.collectionView.registerNib(nibPhotoCellView, forCellWithReuseIdentifier: self.CellId)
        
    }
    
    // MARK: Search bar methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.photos = []
        self.collectionView.reloadData()

        loadDataFromApi(searchBar.text!)
        
    }
    
    // MARK: UICollectionViewController methods
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.CellId, forIndexPath: indexPath) as! PhotoCell
        let index = indexPath.row % photos!.count
        let photo = photos![index]
        cell.imageView?.image = UIImage(named: PLACE_HOLDER_IMAGE_SMALL)
        cell.titleLabel?.text = photo.title
        
        loadImage(photo, imageView: cell.imageView)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let index = indexPath.row % photos!.count
        
        showModal(index)
        
    }
    
    func showModal(index: Int) {
        
        photoPageViewController = PhotoPageViewController(nibName: "PhotoPageView", bundle: nil)
        photoPageViewController!.dataSource = self
        
        let initialContenViewController = self.pageItemAtIndex(index) as PhotoDetailsViewController
        
        let viewControllers = NSArray(object: initialContenViewController)
        
        photoPageViewController?.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        self.presentViewController(photoPageViewController!, animated: true, completion: nil)
        
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.photos?.count)!
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        let cellWidth = calcCellWidth(size)
        layout.itemSize = CGSizeMake(cellWidth, 200)
    }
    
    // MARK: API Methods
    
    func loadDataFromApi(stringToFind: String) -> Void {
        
        checkConection()
        api.apiSearch(stringToFind, completion: didLoadData)
        
    }
    
    // Callback method to received data from API call
    func didLoadData(photos: [Photo]) -> Void {
        
        self.photos = photos
        self.collectionView.reloadData()
        
    }

    // MARK: UI helper methods
    
    func calcCellWidth(size: CGSize) -> CGFloat {
        let transitionToWide = size.width > size.height
        var cellWidth = size.width / 2
        
        if transitionToWide {
            cellWidth = size.width / 3
        }
        
        return cellWidth
    }

}

extension PhotoListViewController: UIPageViewControllerDelegate {
    
    func pageItemAtIndex(index: Int) -> PhotoDetailsViewController
    {
        
        let photoDetailsViewController = PhotoDetailsViewController(nibName: "PhotoDetailsView", bundle: nil)
        photoDetailsViewController.photo = photos![index]

        photoDetailsViewController.pageIndex = index
        
        return photoDetailsViewController
        
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let viewController = viewController as! PhotoDetailsViewController
        var index = viewController.pageIndex! as Int
        
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        index--
        
        return self.pageItemAtIndex(index)
    }

    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let viewController = viewController as? PhotoDetailsViewController
        var index = viewController!.pageIndex! as Int
        
        if (index == NSNotFound) {
            return nil
        }
        
        index++
        
        if (index == photos!.count) {
            return nil
        }
        
        return self.pageItemAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return photos!.count
    }
    
    
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
}








