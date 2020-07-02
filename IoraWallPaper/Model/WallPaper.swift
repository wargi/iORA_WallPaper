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
   var myWallPapers = BehaviorSubject<[MyWallPaper]>(value: [])
   var tags = BehaviorSubject<Tags>(value: Tags(list: [], representImage: []))
   let bag = DisposeBag()
   
   // 데이터 다운로드
   func firebaseDataSetUp(completion: (() -> ())? = nil) {
      PrepareForSetUp.shared.firebaseDataDownload { (datas) in
         self.myWallPapers.onNext(datas)
         PrepareForSetUp.shared.firebaseTagDataDownload { (tags) in
            var resultTags = Tags(list: [], representImage: [])
            tags.forEach { tag in
               let result = datas.filter { $0.wallpaper.tag == tag.info.name }
               let info = Tag(info: tag.info, result: result)
               resultTags.list.append(info)
               resultTags.representImage.append(result[0])
            }
            self.tags.onNext(resultTags)
            completion?()
         }
      }
   }
   
   func wallpaperList() -> Observable<[MyWallPaper]> {
      return myWallPapers
   }
}
