//
//  IoraApp.swift
//  IoraWallPaper
//
//  Created by wargi on 2022/08/20.
//  Copyright © 2022 sangwook park. All rights reserved.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        WallPapers.shared.firebaseDataSetUp()
        if let favArr = UserDefaults.standard.object(forKey: "favoriteArr") as? [String] {
           WallPapers.shared.favoriteArr = favArr
           WallPapers.shared.favoriteSubject.onNext(favArr)
        } else {
           WallPapers.shared.favoriteArr = []
           WallPapers.shared.favoriteSubject.onNext([])
        }
        
        return true
    }
}

@main
struct DogGramApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
