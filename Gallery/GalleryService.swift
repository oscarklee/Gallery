//
//  GalleryService.swift
//  Gallery
//
//  Created by MacPRo on 2/19/16.
//  Copyright © 2016 MacPRo. All rights reserved.
//

import Foundation

protocol GalleryService {
  func getContent(onComplete: (content: [Data]) -> Void)
}