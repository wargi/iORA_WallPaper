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
import Action

class SearchViewModel: CommonViewModel {
   var list: [String]
   var filterd: BehaviorSubject<[String]>
   let popAction: CocoaAction
   
   init(list: [String], filterd: BehaviorSubject<[String]>, sceneCoordinator: SceneCoordinatorType, popAction: CocoaAction? = nil) {
      self.list = list
      self.filterd = BehaviorSubject<[String]>(value: list)
      self.popAction = CocoaAction {
         if let action = popAction {
            action.execute(())
         }
         
         return sceneCoordinator.close(animated: true).asObservable().map { _ in }
      }
      
      super.init(sceneCoordinator: sceneCoordinator)
   }
}
