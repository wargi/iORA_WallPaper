//
//  SceneDelegate.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/08.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   
   var window: UIWindow?
   
   @available(iOS 13.0, *)
   func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      guard let _ = (scene as? UIWindowScene) else { return }
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
