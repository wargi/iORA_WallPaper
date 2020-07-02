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
   let searchAction: CocoaAction
   lazy var wallpapers = BehaviorSubject<[MyWallPaper]>(value: [])
   
   func filteringAction() -> CocoaAction {
      return Action {
         if let wallpapers = try? WallPapers.shared.myWallPapers.value() {
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
   
   init(sceneCoordinator: SceneCoordinatorType, searchAction: CocoaAction? = nil) {
      self.searchAction = CocoaAction { tagList in
         guard let tags = try? WallPapers.shared.tags.value() else { fatalError() }
         if let action = searchAction {
            action.execute(tagList)
         }
         
         let searchViewModel = SearchViewModel(tags: tags, sceneCoordinator: sceneCoordinator)
         let scene = Scene.search(searchViewModel)
         
         return sceneCoordinator.transition(to: scene, using: .push, animated: true).asObservable().map { _ in }
      }
      
      super.init(sceneCoordinator: sceneCoordinator)
   }
}
