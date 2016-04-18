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
    
    func setupUI() {
        
        self.navBar.title = "Flickreando"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let cellWidth = calcCellWidth(self.view.frame.size)
        layout.itemSize = CGSizeMake(cellWidth, cellHeight)
    }
    
    // MARK: Cell registration
    
    func registerCustomCell() {
        
        let nibPhotoCellView = UINib(nibName: "PhotoCellView", bundle: nil)
        self.collectionView.registerNib(nibPhotoCellView, forCellWithReuseIdentifier: self.CellId)
        
    }
    
    // MARK: Search bar methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {

        loadDataFromApi(searchBar.text!)
        
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        if (searchBar.text == "") {
            loadDataFromApi("")
        }
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        deActivateSearchBar()
    }
    
    func deActivateSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    // MARK: UICollectionViewController methods
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.CellId, forIndexPath: indexPath) as! PhotoCell
        let index = indexPath.row % photos!.count
        let photo = photos![index]
        cell.imageView?.image = UIImage(named: PLACE_HOLDER_IMAGE_SMALL)
        cell.titleLabel?.text = photo.title
        
        // load the image asynchronous
        loadImage(photo, imageView: cell.imageView)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let index = indexPath.row % photos!.count
        
        showModal(index)
        
    }
    
    // Load the page view controller responsible for loading each view controller to show title and image
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
    
    // Method resposible for checking the Internet connection and performing the Flickr API call
    func loadDataFromApi(stringToFind: String) {
        
        deActivateSearchBar()
        self.photos = []
        self.collectionView.reloadData()
        checkConection()
        api.apiSearch(stringToFind, completion: didLoadData)
        
    }
    
    // Callback method to received data from lickr API call
    func didLoadData(photos: [Photo]) {
        
        self.photos = photos
        self.collectionView.reloadData()
        if photos.count == 0 {
            showAlert("No results were found.")
        }
        
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
        
        index -= 1
        
        return self.pageItemAtIndex(index)
    }

    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let viewController = viewController as? PhotoDetailsViewController
        var index = viewController!.pageIndex! as Int
        
        if (index == NSNotFound) {
            return nil
        }
        
        index += 1
        
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








