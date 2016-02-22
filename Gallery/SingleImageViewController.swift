//
//  SingleImageViewController.swift
//  Gallery
//
//  Created by MacPRo on 2/21/16.
//  Copyright © 2016 MacPRo. All rights reserved.
//

import Foundation
import UIKit

class SingleImageViewController : UIViewController {
  // navigation item for set the correct title.
  @IBOutlet var navigation: UINavigationItem!
  
  @IBOutlet var imageView: UIImageView!
  
  @IBOutlet var spinner: UIActivityIndicatorView!
  
  func setLabel(label: String) {
    navigation.title = label
  }
  
  func setImage(url: NSURL) {
    Utils.downloadImage(url) {
      (image: UIImage?) -> Void in
      
      // set the image in the image view.
      if image == nil {
        self.imageView.backgroundColor = UIColor.blackColor()
        
        //hide the spinner.
        self.spinner.hidden = true
        
      } else {
        self.imageView.image = image
        
        // stop the spinner.
        self.spinner.stopAnimating()
      }
    }
  }
}