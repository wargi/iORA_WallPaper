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
      if let tabbar = self.tabBarController as? CustomTabbarController{
         tabbar.coordinator = viewModel.sceneCoordinator
      }
      WallPapers.shared.wallpaperSubject
         .bind(to: collectionView.rx.items(cellIdentifier: WallPaperCollectionViewCell.identifier)) { index, wallpaper, cell in
            print(index)
      }
      .disposed(by: rx.disposeBag)
   }
}

extension FavoriteViewController: UICollectionViewDelegate {
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
}
