//
//  CategoryViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/11.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, ViewModelBindableType {
   var viewModel: CategoryViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
      
   func bindViewModel() {
      if let tabbarVC = self.tabBarController as? CustomTabbarController {
         tabbarVC.coordinator = viewModel.sceneCoordinator
      }
   }
}
