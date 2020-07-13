//
//  CategoryViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/11.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class CategoryViewController: UIViewController, ViewModelBindableType {
   var viewModel: CategoryViewModel!
   @IBOutlet private weak var collectionView: UICollectionView!
   let bag = DisposeBag()
   override func viewDidLoad() {
      super.viewDidLoad()
      
      if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
         guard let deviceSize = PrepareForSetUp.shared.displayType else { return }
         
         let collectionViewSize = collectionView.bounds.size
         layout.minimumLineSpacing = 30
         layout.minimumInteritemSpacing = 0
         
         if deviceSize == .retina {
            let width = collectionViewSize.width * 0.8
            layout.itemSize = CGSize(width: width, height: width * 1.77)
         } else {
            let width = collectionViewSize.width * 0.88
            layout.itemSize = CGSize(width: width, height: width * 2.16)
         }
      }
   }
      
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      if let tabbar = self.tabBarController as? CustomTabbarController {
         tabbar.coordinator = viewModel.sceneCoordinator
      }
   }
   func bindViewModel() {
      viewModel.categorySubject.bind(to: collectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.identifier,
                                        cellType: CategoryCollectionViewCell.self)) { index, tag, cell in
                                          
      }.disposed(by: bag)
      
   }
}

extension CategoryViewController: UICollectionViewDelegate {
}
