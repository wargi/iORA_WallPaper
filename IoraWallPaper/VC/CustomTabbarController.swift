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
   @IBOutlet private weak var tabbar: UITabBar!
   var coordinator: SceneCoordinatorType?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.delegate = self
      // Do any additional setup after loading the view.
   }
}

extension CustomTabbarController: UITabBarControllerDelegate {
   func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
      guard let nav = viewController as? UINavigationController,
         let coordinator = coordinator,
         let title = nav.title else { return true }
      
      if viewController is MainViewController {
         
         let viewModel = MainViewModel(sceneCoordinator: coordinator)
         let scene = Scene.main(viewModel)
         
         coordinator.transition(to: scene, using: .tap, animated: false)
      }
      
//      switch NavigationTitle(rawValue: title) {
//      case .mainNav:
//         let viewModel = MainViewModel(sceneCoordinator: coordinator)
//         scene = Scene.main(viewModel)
//      case .favoriteNav:
//         let viewModel = FavoriteViewModel(sceneCoordinator: coordinator)
//         scene = Scene.favorite(viewModel)
//      case .categoryNav:
//         let viewModel = CategoryViewModel(sceneCoordinator: coordinator)
//         scene = Scene.category(viewModel)
//      default:
//         fatalError()
//      }
      
      return true
   }
}
