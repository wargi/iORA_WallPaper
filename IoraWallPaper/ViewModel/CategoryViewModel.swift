//
//  CategoryViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/11.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx
import Action

class CategoryViewModel: CommonViewModel {
   var categories: Tags
   var categorySubject: BehaviorSubject<[Tag]>
   var selectAction: CocoaAction

   func setCategory() {
      WallPapers.shared.tagSubject
         .subscribe(onNext: {
            self.categories = $0
            self.categorySubject.onNext($0.list)
         })
         .disposed(by: rx.disposeBag)
      
   }
   
   init(selectAction: CocoaAction? = nil, sceneCoordinator: SceneCoordinatorType) {
      self.selectAction = CocoaAction { empty in
         if let selectAction = selectAction {
            selectAction.execute()
         }
         
         return Observable.empty()
      }
      self.categories = WallPapers.shared.tags
      self.categorySubject = BehaviorSubject<[Tag]>(value: [])
      super.init(sceneCoordinator: sceneCoordinator)
      
      setCategory()
   }
}
