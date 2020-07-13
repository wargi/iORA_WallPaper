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
         print(currentVC, target)
         currentVC = target.sceneViewController
         window.rootViewController = target
         subject.onCompleted()
      case .push:
         print(currentVC, target)
         if let nav = currentVC.navigationController {
            print("nav")
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
         } else if let tabbar = currentVC.tabBarController,
            let nav = tabbar.navigationController {
            print("tabbar")
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
         } else if let nav = currentVC as? UINavigationController {
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
         } else {
            print("onError")
            subject.onError(TransitionError.navigationControllerMissing)
            break
         }

         subject.onCompleted()
      case .modal:
         currentVC.present(target, animated: animated) {
            subject.onCompleted()
         }
         currentVC = target.sceneViewController
      case .tap:
         if let navi = target as? UINavigationController {
            currentVC = target
         } else {
            currentVC = target
         }
         
         print(target)
         subject.onCompleted()
      }
      return subject.ignoreElements()
   }
   
   func close(animated: Bool) -> Completable {
      Completable.create { [unowned self] completable in
         if let nav = self.currentVC.navigationController {
            guard nav.popViewController(animated: animated) != nil else {
               completable(.error(TransitionError.cannotPop))
               return Disposables.create()
            }
            self.currentVC = nav.viewControllers.last!
            completable(.completed)
         } else if let presentingVC = self.currentVC.presentingViewController {
            self.currentVC.dismiss(animated: animated) {
               self.currentVC = presentingVC.sceneViewController
               completable(.completed)
            }
         } else {
            completable(.error(TransitionError.unknown))
         }
         return Disposables.create()
      }
   }
}
