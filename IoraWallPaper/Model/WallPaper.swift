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
   let wallpaperSubject = BehaviorSubject<[MyWallPaper]>(value: [])
   
   var favoriteArr = [String]()
   var favoriteSubject = BehaviorSubject<[String]>(value: [])
   
   var tags = [Tag]()
   let tagSubject = BehaviorSubject<[Tag]>(value: [])
   
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
               self.tags.append(info)
            }
            
            self.tags.reverse()
            self.tagSubject.onNext(self.tags)
         }
      }
   }
   
   func subscribeFavorite() {

   }
}
