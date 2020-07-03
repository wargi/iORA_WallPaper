//
//  ShowPreViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/25.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class ShowPreViewModel: CommonViewModel {
   // 배경 화면 관련
   let wallpaper: MyWallPaper
   public var info: BehaviorSubject<MyWallPaper>
   
   //MARK: Button Action
   var closeAction: CocoaAction
   
   init(wallpaper: MyWallPaper, sceneCoordinator: SceneCoordinatorType, closeAction: CocoaAction? = nil) {
      self.wallpaper = wallpaper
      self.info = BehaviorSubject<MyWallPaper>(value: wallpaper)
      
      self.closeAction = CocoaAction {
         if let action = closeAction {
            action.execute(())
         }
         
         return sceneCoordinator.close(animated: true).asObservable().map { _ in }
      }
      
      super.init(sceneCoordinator: sceneCoordinator)
   }
}
