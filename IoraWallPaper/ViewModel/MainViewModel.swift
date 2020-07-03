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

class MainViewModel: CommonViewModel {
   var wallpapers: [MyWallPaper]
   var presentWallpapers: BehaviorSubject<[MyWallPaper]>
   var isPresenting: BehaviorSubject<Bool>
   
   var isPresent = true
   var reverse = false
   let searchAction: CocoaAction
   let selectedAction: Action<[MyWallPaper], Void>
   
   func presentAction() {
      isPresent = !isPresent
      
      if isPresent {
         let wallpaper = reverse ? WallPapers.shared.myWallPapers.reversed() : WallPapers.shared.myWallPapers
         presentWallpapers.onNext(wallpaper)
         wallpapers = wallpaper
      } else {
         presentWallpapers.onNext(WallPapers.shared.tags.representImage)
      }
      
      isPresenting.onNext(isPresent)
   }
   
   func setData() {
      Observable.zip(WallPapers.shared.wallpaperSubject, WallPapers.shared.tagSubject)
         .take(2)
         .map { $0.0 }
         .subscribe(onNext: {
            self.wallpapers = $0
            self.presentWallpapers.onNext($0)
         })
         .disposed(by: rx.disposeBag)
   }
   
   init(sceneCoordinator: SceneCoordinatorType, filteringAction: CocoaAction? = nil, searchAction: CocoaAction? = nil, selectedAction: Action<[MyWallPaper], Void>? = nil) {
      self.wallpapers = []
      self.presentWallpapers = BehaviorSubject<[MyWallPaper]>(value: wallpapers)
      self.isPresenting = BehaviorSubject<Bool>(value: true)
      
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
      
      self.setData()
   }
}
