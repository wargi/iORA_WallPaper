//
//  FavoriteViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/11.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteViewController: UIViewController, ViewModelBindableType {
   @IBOutlet private weak var collectionView: UICollectionView!
   var viewModel: FavoriteViewModel!

   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   func bindViewModel() {
      if let tabbarVC = self.tabBarController as? CustomTabbarController {
         tabbarVC.coordinator = viewModel.sceneCoordinator
      }
   }
}

extension FavoriteViewController: UICollectionViewDelegate {
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
}
