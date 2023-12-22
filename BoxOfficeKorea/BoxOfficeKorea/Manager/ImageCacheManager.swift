//
//  ImageCacheManager.swift
//  BoxOfficeKorea
//
//  Created by wooseob on 12/22/23.
//

import Foundation
import UIKit

final class ImageCacheManager {
  let shared = NSCache<NSString, UIImage>()
  
  private init() {}
}
