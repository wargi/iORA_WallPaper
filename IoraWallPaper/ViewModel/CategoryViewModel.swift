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
import Action

class CategoryViewModel {
   let disposedBag = DisposeBag()
   var categories: Tags
   var categorySubject: BehaviorSubject<[Tag]>
   var selectAction: CocoaAction

   func setCategory() {
      WallPapers.shared.tagSubject
         .subscribe(onNext: {
            self.categories = $0
            self.categorySubject.onNext($0.list)
         })
         .disposed(by: disposedBag)
      
   }
   
   init(selectAction: CocoaAction? = nil) {
      self.selectAction = CocoaAction { empty in
         if let selectAction = selectAction {
            selectAction.execute()
         }
         
         return Observable.empty()
      }
      self.categories = WallPapers.shared.tags
      self.categorySubject = BehaviorSubject<[Tag]>(value: [])
      
      setCategory()
   }
}
