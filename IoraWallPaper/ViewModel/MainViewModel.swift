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
import RxDataSources

class MainViewModel: CommonViewModel {
   var wallpapers: [MyWallPaper]
   var presentWallpapers: BehaviorSubject<[MyWallPaper]>
   var reverse = false
   let searchAction: CocoaAction
   let selectedAction: Action<[MyWallPaper], Void>
   
   func setMyWallpaper() {
      WallPapers.shared.wallpaperSubject
         .subscribe(onNext: {
            self.presentWallpapers.onNext($0)
         })
         .disposed(by: rx.disposeBag)
   }
   
   init(sceneCoordinator: SceneCoordinatorType, filteringAction: CocoaAction? = nil, searchAction: CocoaAction? = nil, selectedAction: Action<[MyWallPaper], Void>? = nil) {
      self.wallpapers = []
      self.presentWallpapers = BehaviorSubject<[MyWallPaper]>(value: wallpapers)
      
      self.searchAction = CocoaAction { tagList in
         if let action = searchAction {
            action.execute(tagList)
         }
         
         let searchViewModel = SearchViewModel(tags: WallPapers.shared.tags, sceneCoordinator: sceneCoordinator)
         let scene = Scene.search(searchViewModel)
         
         return sceneCoordinator.transition(to: scene, using: .push, animated: true).asObservable().map { _ in }
      }
      
      self.selectedAction = Action<[MyWallPaper], Void> { wallpapers in
         if let action = selectedAction {
            action.execute(wallpapers)
         }
         
         let viewModel = DetailImageViewModel(wallpapers: wallpapers, sceneCoordinator: sceneCoordinator)
         let scene = Scene.detailImage(viewModel)
         
         return sceneCoordinator.transition(to: scene, using: .push, animated: true).asObservable().map { _ in }
      }
      
      super.init(sceneCoordinator: sceneCoordinator)
      
      setMyWallpaper()
   }
}
