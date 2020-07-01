//
//  WallPaper.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/10.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Foundation

// 받아오는 데이터
struct ImageInfo: Codable {
   let brightness: Int // brightness
   let imageName: String // imageName
   let imageType: ImageType // imageType
   let tag: String
}

class MyWallPaper {
   let wallpaper: ImageInfo
   var image: UIImage?
   
   init(info: ImageInfo) {
      self.wallpaper = info
      self.image = nil
   }
}

class WallPapers {
   static let shared = WallPapers()
   var myWallPapers: [MyWallPaper] = []
   var tags: [Tag] = []
   
   // 데이터 다운로드
   func firebaseDataSetUp(completion: (() -> ())? = nil) {
      myWallPapers.removeAll()
      
      PrepareForSetUp.shared.firebaseDataDownload { (datas) in
         self.myWallPapers = datas
         PrepareForSetUp.shared.firebaseTagDataDownload { (tags) in
            self.tags = tags
            
            self.tags = self.tags.map { tag in
               let wallpapers = self.myWallPapers.filter { tag.info.name == $0.wallpaper.tag }
               return Tag(info: tag.info, result: wallpapers)
            }
            
            completion?()
         }
      }
   }
}
