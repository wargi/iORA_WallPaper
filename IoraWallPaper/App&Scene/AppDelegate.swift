//
//  AppDelegate.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/08.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
      FirebaseApp.configure()
      
      // (414.0, 896.0) // 11 pro max
      // (375.0, 812.0) // 11 pro
      // (414.0, 896.0) // 11
      // (414.0, 736.0) // 8 plus
      // (375.0, 667.0) // se
      // (375.0, 667.0) // 8
      
      switch UIScreen.main.bounds.size.height {
      case 896, 812:
         WallPapers.shared.displayType = .superRetina
      case 736, 667:
         WallPapers.shared.displayType = .retina
      default:
         break
      }
      
      return true
   }

   // MARK: UISceneSession Lifecycle
   @available(iOS 13.0, *)
   func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
   }

   @available(iOS 13.0, *)
   func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
   }
}

