//
//  ItemCollectionViewCell.swift
//  Gallery
//
//  Created by MacPRo on 2/18/16.
//  Copyright © 2016 MacPRo. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
  // image of the cell.
  @IBOutlet var thumbnail: UIImageView!
  
  var imageUrl: NSURL = NSURL()
  
  func setItemCornerRadius(radious r: Float) {
    thumbnail.layer.cornerRadius = CGFloat(r)
    thumbnail.layer.borderWidth = 1
  }
}
