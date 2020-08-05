//
//  AppDelegate.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/08.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import GoogleMobileAds
import NSObject_Rx

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var window: UIWindow?
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      FirebaseApp.configure()
      GADMobileAds.sharedInstance().start(completionHandler: nil)
      Messaging.messaging().delegate = self
      UNUserNotificationCenter.current().delegate = self
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
         options: authOptions,
         completionHandler: {_, _ in })
      application.registerForRemoteNotifications()
      
      WallPapers.shared.firebaseDataSetUp()
      if let favArr = UserDefaults.standard.object(forKey: "favoriteArr") as? [String] {
         print(favArr)
         WallPapers.shared.favoriteArr = favArr
         WallPapers.shared.favoriteSubject.onNext(favArr)
      } else {
         WallPapers.shared.favoriteArr = []
         WallPapers.shared.favoriteSubject.onNext([])
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
