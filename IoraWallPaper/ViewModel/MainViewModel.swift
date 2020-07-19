//
//  MainViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/25.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MainViewModel {
   let disposedBag = DisposeBag()
   
   var reachability: Reachability? = Reachability()
   var wallpapers: [MyWallPaper]
   var presentWallpapers: BehaviorSubject<[MyWallPaper]>
   var reverse = false
   
   func setMyWallpaper() {
      WallPapers.shared.wallpaperSubject
         .subscribe(onNext: {
            self.presentWallpapers.onNext($0)
         })
         .disposed(by: disposedBag)
   }
   
   init() {
      self.wallpapers = []
      self.presentWallpapers = BehaviorSubject<[MyWallPaper]>(value: wallpapers)
      
      setMyWallpaper()
   }
}
