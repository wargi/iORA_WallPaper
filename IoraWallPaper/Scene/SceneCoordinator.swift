//
//  SceneCoordinator.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/26.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift

extension UIViewController {
   var sceneViewController: UIViewController {
      return self.children.first ?? self
   }
}

class SceneCoordinator: SceneCoordinatorType {
   private let bag = DisposeBag()
   
   private var window: UIWindow
   private var currentVC: UIViewController
   
   required init(window: UIWindow) {
      self.window = window
      currentVC = window.rootViewController!
   }
   
   @discardableResult
   func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
      let subject = PublishSubject<Void>()
      let target = scene.instantiate()
      
      switch style {
      case .root:
         currentVC = target.sceneViewController
         window.rootViewController = target
         subject.onCompleted()
      case .push:
         guard let nav = currentVC.navigationController else {
            subject.onError(TransitionError.navigationControllerMissing)
            break
         }
         
         nav.pushViewController(target, animated: animated)
         currentVC = target.sceneViewController
         
         subject.onCompleted()
      case .modal:
         currentVC.present(target, animated: animated) {
            subject.onCompleted()
         }
         currentVC = target.sceneViewController
      }
      return subject.ignoreElements()
   }
   
   func close(animated: Bool) -> Completable {
      Completable.create { [unowned self] completable in
         if let presentingVC = self.currentVC.presentingViewController {
            self.currentVC.dismiss(animated: animated) {
               self.currentVC = presentingVC.sceneViewController
               completable(.completed)
            }
         } else if let nav = self.currentVC.navigationController {
            guard nav.popViewController(animated: animated) != nil else {
               completable(.error(TransitionError.cannotPop))
               return Disposables.create()
            }
            self.currentVC = nav.viewControllers.last!
            completable(.completed)
         } else {
            completable(.error(TransitionError.unknown))
         }
         return Disposables.create()
      }
   }
}
