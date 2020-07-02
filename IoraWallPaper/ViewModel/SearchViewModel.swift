//
//  SearchViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/25.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx
import Action

class SearchViewModel: CommonViewModel {
   var tags: Tags
   var list: [String]
   var filterd: BehaviorSubject<[String]>
   let popAction: CocoaAction
   let searchResultAction: Action<String, Void>
   
   init(tags: Tags, sceneCoordinator: SceneCoordinatorType, searchResultAction: Action<String, Void>? = nil, popAction: CocoaAction? = nil) {
      self.tags = tags
      self.list = tags.list.map { $0.info.name }
      self.filterd = BehaviorSubject<[String]>(value: list)
      
      self.popAction = CocoaAction {
         if let action = popAction {
            action.execute(())
         }
         
         return sceneCoordinator.close(animated: true).asObservable().map { _ in }
      }
      
      self.searchResultAction = Action<String, Void> { tagName in
         if let action = searchResultAction {
            action.execute(tagName)
         }
         
         guard let tags = try? WallPapers.shared.tags.value(),
            let tag = tags.list.first(where: { $0.info.name == tagName }) else { fatalError() }
         
         let viewModel = SearchResultViewModel(tag: tag, sceneCoordinator: sceneCoordinator)
         let scene = Scene.searchResult(viewModel)
         
         return sceneCoordinator.transition(to: scene, using: .push, animated: true).asObservable().map { _ in }
      }
      
      super.init(sceneCoordinator: sceneCoordinator)
   }
}
