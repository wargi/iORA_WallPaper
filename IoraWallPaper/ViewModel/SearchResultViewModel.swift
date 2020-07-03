//
//  SearchResultViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/25.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class SearchResultViewModel: CommonViewModel {
   let tag: Tag
   var title: Driver<String>
   let wallpapers: BehaviorSubject<[MyWallPaper]>
   let showDetailAction: Action<MyWallPaper, Void>
   let popAction: CocoaAction
   
   init(tag: Tag, sceneCoordinator: SceneCoordinatorType, showDetailAction: Action<MyWallPaper, Void>? = nil, popAction: CocoaAction? = nil) {
      self.tag = tag
      self.title = Observable.just(tag.info.name).asDriver(onErrorJustReturn: "")
      self.wallpapers = BehaviorSubject<[MyWallPaper]>(value: tag.result)
      self.showDetailAction = Action<MyWallPaper, Void> { wallpaper in
         if let action = showDetailAction {
            action.execute(wallpaper)
         }
         
         let viewModel = DetailImageViewModel(wallpapers: [wallpaper], sceneCoordinator: sceneCoordinator)
         let scene = Scene.detailImage(viewModel)
         
         return sceneCoordinator.transition(to: scene, using: .push, animated: true).asObservable().map { _ in }
      }
      
      self.popAction = CocoaAction {
         if let action = popAction {
            action.execute(())
         }
         
         return sceneCoordinator.close(animated: true).asObservable().map { _ in }
      }
      
      super.init(sceneCoordinator: sceneCoordinator)
   }
   
}
