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
      
      guard let coordinator = coordinator else { return true }
      var scene: Scene?
      
      if viewController is MainViewController {
         let viewModel = MainViewModel(sceneCoordinator: coordinator)
         scene = Scene.main(viewModel) 
      } else if viewController is FavoriteViewController {
         let viewModel = FavoriteViewModel(sceneCoordinator: coordinator)
         scene = Scene.favorite(viewModel)
      } else if viewController is CategoryViewController {
         let viewModel = CategoryViewModel(sceneCoordinator: coordinator)
         scene = Scene.category(viewModel)
      }

      if let scene = scene {
         coordinator.transition(to: scene, using: .tap, animated: false)
      }
      
      
      return true
   }
}
