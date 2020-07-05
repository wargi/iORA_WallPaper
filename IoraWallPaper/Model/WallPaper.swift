//
//  WallPaper.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/10.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

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
   var myWallPapers = [MyWallPaper]()
   var tags = Tags(list: [], representImage: [])
   let wallpaperSubject = BehaviorSubject<[MyWallPaper]>(value: [])
   let tagSubject = BehaviorSubject<Tags>(value: Tags(list: [], representImage: []))
   let bag = DisposeBag()
   
   // 데이터 다운로드
   func firebaseDataSetUp(completion: (() -> ())? = nil) {
      PrepareForSetUp.shared.firebaseDataDownload { (datas) in
         self.myWallPapers = datas
         self.wallpaperSubject.onNext(datas)
         PrepareForSetUp.shared.firebaseTagDataDownload { (tags) in
            tags.forEach { tag in
               let result = datas.filter { $0.wallpaper.tag == tag.info.name }
               let info = Tag(info: tag.info, result: result)
               self.tags.list.append(info)
               self.tags.representImage.append(result[0])
            }
            self.tags.list.sort { lhs, rhs in
               lhs.info.name < rhs.info.name
            }
            var result = [MyWallPaper]()
            for index in 0 ..< self.tags.list.count {
               result.append(self.tags.representImage[index])
            }
            
            self.tags.representImage = result
            self.tagSubject.onNext(self.tags)
         }
      }
   }
}
