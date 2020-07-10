//
//  InitialLaunchViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/09.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class InitialLaunchViewModel: CommonViewModel {
   var imagesSubject: BehaviorSubject<[UIImage?]>
   func okAction() -> Observable<Void> {
      let mainViewModeel = MainViewModel(sceneCoordinator: sceneCoordinator)
      let mainScene = Scene.main(mainViewModeel)
      
      return sceneCoordinator.transition(to: mainScene, using: .modal, animated: true).asObservable().map { _ in }
   }
   
   init(images: [UIImage?], sceneCoordinator: SceneCoordinatorType) {
      self.imagesSubject = BehaviorSubject<[UIImage?]>(value: images)
      
      super.init(sceneCoordinator: sceneCoordinator)
   }
}