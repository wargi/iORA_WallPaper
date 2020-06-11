//
//  WallPaper.swift
//  IoraWallPaper
//
//  Created by 박소정 on 2020/06/10.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import UIKit

struct WallPaper {
   let imageName: String
   let imageURL: String
   let tag: String?
   let brightness: Int
}


class WallPapers {
   static let shared = WallPapers()
   
   var images: [UIImage?] = []
   var data: [WallPaper] = []
   private init() {}
   
   func prepareWallPapers() {
      
   }
}
