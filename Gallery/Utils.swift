//
//  Utils.swift
//  Gallery
//
//  Created by MacPRo on 2/21/16.
//  Copyright © 2016 MacPRo. All rights reserved.
//

import Foundation
import UIKit

class Utils {
  // MARK: - given an url download the image and set in the onComplete handler.
  static func downloadImage(url: NSURL, onComplete: (image: UIImage?) -> Void) {
    // get the shared session.
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithURL(url) {
      (data, response: NSURLResponse?, error: NSError?) -> Void in
      
      // if no error then get the image.
      if error == nil {
        let httpResponse = response as? NSHTTPURLResponse
        
        if httpResponse?.statusCode == 200 {
          // use async queues.
          dispatch_async(dispatch_get_main_queue()) {
            // get the image and set it in the handler.
            let data = NSData(data: data!)
            onComplete(image: UIImage(data: data)!)
          }
        } else if httpResponse?.statusCode == 404 {
          // if image not found.
          onComplete(image: nil)
        }
      }
    }
    
    // perform the task.
    task.resume()
  }
}