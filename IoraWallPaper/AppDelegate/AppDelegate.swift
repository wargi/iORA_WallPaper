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
      
      Messaging.messaging().delegate = self
      UNUserNotificationCenter.current().delegate = self
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
         options: authOptions,
         completionHandler: {_, _ in })
      application.registerForRemoteNotifications()
      
      WallPapers.shared.getDeviceScreenSize()
      WallPapers.shared.dataDownload {
         DispatchQueue.main.async {
            let set: Set<String> = Set(WallPapers.shared.tags)
            WallPapers.shared.tags = Array(set)
            WallPapers.shared.tags.sort()
            WallPapers.shared.randomDatas = WallPapers.shared.datas.shuffled()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didFinishLaunchingWithOptions"),
                                            object: nil)
         }
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

extension AppDelegate: UNUserNotificationCenterDelegate {
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      
   }
}

extension AppDelegate: MessagingDelegate {
   func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      let dataDict:[String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
   }
}
