//
//  CustomTabbarController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/12.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum NavigationTitle: String {
   case mainNav = "mainNav"
   //   case favoriteNav = "favoriteNav"
   //   case categoryNav = "categoryNav"
}

enum TabbarVC {
   case mainVC(MainViewController)
   case favoriteVC(FavoriteViewController)
   case categoryVC(CategoryViewController)
}

class CustomTabbarController: UITabBarController {
   static let identifier = "CustomTabbarController"
   
   override func viewDidLoad() {
      super.viewDidLoad()
      tabBar.unselectedItemTintColor = UIColor.darkGray
      setTabbarColor()
   }
   
   func setTabbarColor() {
      if #available(iOS 13, *) {
          let appearance = UITabBarAppearance()
         appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
         appearance.stackedLayoutAppearance.normal.iconColor = .darkGray
          tabBar.standardAppearance = appearance
      }
   }
}
