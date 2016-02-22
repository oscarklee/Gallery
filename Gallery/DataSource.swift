//
//  DataSource.swift
//  Gallery
//
//  Created by MacPRo on 2/18/16.
//  Copyright © 2016 MacPRo. All rights reserved.
//

import UIKit

class DataSource: NSObject, UICollectionViewDataSource {
  // identifier for the reuse cell.
  let reuseIdentifier = "CellPhoto"
  
  // data object with all the content of the service.
  var data:[Data] = []
  
  let mainContentUrl = ""
  
  // MARK: - return the number of items in the gallery.
  @objc func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //return data array size
    return data.count
  }
  
  // MARK: - configure the cell.
  @objc func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
      // get the CellPhoto cell for reuse for this other cell.
      let newCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as!ItemCollectionViewCell
      
      // cell width
      let cellWidth:Float = Float(newCell.frame.width)
      
      // set corner radius of the cell.
      newCell.setItemCornerRadius(radious: cellWidth/16)
      
      // placeholder until the image is downloaded.
      newCell.thumbnail.image = UIImage(named: "Loading")
      
      // get the thumbnail url.
      let thumbnailUrl = data[indexPath.row].thumbnail
      
      // set the image url.
      newCell.imageUrl = data[indexPath.row].image
      
      // call to download the image async.
      Utils.downloadImage(thumbnailUrl) {
        (image: UIImage?) -> Void in
        
        // set the image in the new cell.
        if image != nil {
          newCell.thumbnail.image = image
        }
      }
      
      return newCell
  }
}