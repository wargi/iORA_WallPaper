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
   public var info: BehaviorSubject<MyWallPaper>
   
   //MARK: Button Action
   // 파일 다운로드 Action
   var saveAction: Action<UIImage?, Void>
   var closeAction: CocoaAction
   
   init(info: BehaviorSubject<MyWallPaper>, sceneCoordinator: SceneCoordinatorType, saveAction: Action<UIImage?, Void>? = nil, closeAction: CocoaAction? = nil) {
      self.info = info
      
      self.saveAction = Action<UIImage?, Void> { image in
         if let action = saveAction {
            action.execute(image)
         }
         
         PrepareForSetUp.shared.imageFileDownload(image: image)
         PrepareForSetUp.shared.completedAlert { (_) in
            sceneCoordinator.close(animated: true)
         }
         return Observable.just(())
      }
      
      self.closeAction = CocoaAction {
         if let action = closeAction {
            action.execute(())
         }
         
         return sceneCoordinator.close(animated: true).asObservable().map { _ in }
      }
      
      super.init(sceneCoordinator: sceneCoordinator)
   }
}
