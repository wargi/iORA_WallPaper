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

class MainViewModel: CommonViewModel {
   var flag = true
   lazy var wallpapers = BehaviorSubject<[MyWallPaper]>(value: [])
   
   func filteringAction() -> CocoaAction {
      return Action {
         print("T")
         if let wallpapers = try? WallPapers.shared.myWallPapers.value() {
            print("A")
            self.wallpapers.onNext(wallpapers.reversed())
         }
         
         return Observable.just(())
      }
   }
   
   func presentingAction() -> CocoaAction {
      return Action {
         self.flag = !self.flag
         if self.flag, let wallpapers = try? WallPapers.shared.myWallPapers.value() {
            self.wallpapers.onNext(wallpapers)
         } else {
            if let value = try? WallPapers.shared.tags.value() {
               self.wallpapers.onNext(value.representImage)
            }
         }
         return Observable.just(())
      }
   }
   
   override init(sceneCoordinator: SceneCoordinatorType) {
      super.init(sceneCoordinator: sceneCoordinator)
      
   }
}
