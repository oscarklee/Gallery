//
//  ViewController.swift
//  Gallery
//
//  Created by MacPRo on 2/16/16.
//  Copyright © 2016 MacPRo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  // now the bing service is the one implemented.
  let service: GalleryService = BingService()
  
  // outlet - list of photos in the view.
  @IBOutlet var photoCollectionView: UICollectionView!
  
  // outlet - loading icon.
  @IBOutlet var spinner: UIActivityIndicatorView!
  
  // action when the refresh button is pressed.
  @IBAction func onPressRefresh(sender: UIBarButtonItem) {
    //refresh the gallery.
    loadGallery(service)
  }
  
  // MARK: - function when it loads.
  override func viewDidLoad() {
    // call the parent load.
    super.viewDidLoad()
    
    // change the status bar style, for get a white color in font.
    UIApplication.sharedApplication().statusBarStyle = .LightContent
    
    // load the gallery with the given service.
    loadGallery(service)
  }
  
  // MARK: - Get the related view for set all the content parameters.
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // find selected photo index path
    let clickedIndexPath : [NSIndexPath] = self.photoCollectionView!.indexPathsForSelectedItems()!
    
    // create destination view controller
    let singleImageViewController = segue.destinationViewController as! SingleImageViewController
    
    // get the collection view data source.
    let dataSource: DataSource = self.photoCollectionView.dataSource as! DataSource
    
    // get the selected data content.
    let data:Data = dataSource.data[clickedIndexPath[0].row]
    
    // set all the content from the selected data.
    singleImageViewController.setLabel(data.label)
    singleImageViewController.setImage(data.image)
  }
  
  func loadGallery(service: GalleryService) {
    // this method returns the content if a data array.
    service.getContent() {
      (content: [Data]) in
      
      // set the content in the data source.
      let dataSource: DataSource = self.photoCollectionView.dataSource as! DataSource
      dataSource.data = content
      
      // it is important only modify the ui in the main thread.
      dispatch_async(dispatch_get_main_queue()) {
        self.photoCollectionView.reloadData()
      }
      
      // stop the loading icon.
      self.spinner.stopAnimating()
    }
  }
}

