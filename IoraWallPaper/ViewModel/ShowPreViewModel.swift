//
//  ShowPreViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/25.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class ShowPreViewModel {
   // 배경 화면 관련
   let wallpaper: MyWallPaper
   public var info: BehaviorSubject<MyWallPaper>
   
   func downloadAction() -> UIAlertController {
      guard let alert = PrepareForSetUp.shared.imageFileDownload(image: wallpaper.image) else {
         fatalError()
      }
      
      return alert
   }
   
   init(wallpaper: MyWallPaper) {
      self.wallpaper = wallpaper
      self.info = BehaviorSubject<MyWallPaper>(value: wallpaper)
   }
}
