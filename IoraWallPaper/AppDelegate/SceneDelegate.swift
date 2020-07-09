//
//  SceneDelegate.swift
//  RxMemoByKx
//
//  Created by 박상욱 on 2020/06/24.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   
   var window: UIWindow?
   
   @available(iOS 13.0, *)
   func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      guard let _ = (scene as? UIWindowScene) else { return }
      
      let coordinator = SceneCoordinator(window: window!)
      var scene: Scene
      
      let isLaunch = UserDefaults.standard.object(forKey: "isLaunch") as? Bool ?? false
      
      if isLaunch {
         let mainListViewModel = MainViewModel(sceneCoordinator: coordinator)
         scene = Scene.main(mainListViewModel)
      } else {
         guard let displayType = PrepareForSetUp.shared.displayType else { return }
         var images: [UIImage?]
         if displayType == .retina {
            images = [
               UIImage(named: "rlanding_detail"),
               UIImage(named: "rlanding_calendar"),
               UIImage(named: "rlanding_watch")
            ]
         } else {
            images = [
               UIImage(named: "slanding_detail"),
               UIImage(named: "slanding_calendar"),
               UIImage(named: "slanding_watch")
            ]
         }
         
         let initialLaunchViewModel = InitialLaunchViewModel(images: images, sceneCoordinator: coordinator)
         scene = Scene.initialLaunch(initialLaunchViewModel)
      }
      
      coordinator.transition(to: scene, using: .root, animated: true)
   }

   @available(iOS 13.0, *)
   func sceneDidDisconnect(_ scene: UIScene) {
   }

   @available(iOS 13.0, *)
   func sceneDidBecomeActive(_ scene: UIScene) {
   }

   @available(iOS 13.0, *)
   func sceneWillResignActive(_ scene: UIScene) {
   }

   @available(iOS 13.0, *)
   func sceneWillEnterForeground(_ scene: UIScene) {
   }

   @available(iOS 13.0, *)
   func sceneDidEnterBackground(_ scene: UIScene) {
   }
}

