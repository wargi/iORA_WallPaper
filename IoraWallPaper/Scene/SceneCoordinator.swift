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
   
   var rootViewController: UIViewController {
      return self.tabBarController ?? self
   }
}

class SceneCoordinator: SceneCoordinatorType {
   private let bag = DisposeBag()
   
   private var window: UIWindow
   private var currentVC: UIViewController
   private var lastMain: UIViewController?
   
   required init(window: UIWindow) {
      self.window = window
      currentVC = window.rootViewController!
   }
   
   @discardableResult
   func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
      let subject = PublishSubject<Void>()
      let target = scene.instantiate()
      print(currentVC, target)
      switch style {
      case .root:
         currentVC = target.sceneViewController
         window.rootViewController = target.rootViewController
         subject.onCompleted()
      case .push:
         if currentVC is UINavigationController {
            let nav = currentVC.sceneViewController.navigationController
            nav?.pushViewController(target.sceneViewController, animated: animated)
            currentVC = target.sceneViewController
         } else if let nav = currentVC.navigationController {
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
         } else {
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
         
         if currentVC.navigationController?.tabBarController?.view.tag == 0 {
            if let vc = lastMain {
               currentVC = vc
            } else {
               lastMain = currentVC
            }
         } else {
            currentVC = target.sceneViewController
         }
         
         
         subject.onCompleted()
      }
      return subject.ignoreElements()
   }
   
   func close(animated: Bool) -> Completable {
      Completable.create { [unowned self] completable in
         if self.currentVC is UINavigationController {
            let vc = self.currentVC.sceneViewController
            guard let nav = vc.navigationController,
               nav.popViewController(animated: animated) != nil else {
                  completable(.error(TransitionError.cannotPop))
                  return Disposables.create()
            }
            self.currentVC = nav.viewControllers.last!
            completable(.completed)
         } else if let nav = self.currentVC.navigationController {
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
