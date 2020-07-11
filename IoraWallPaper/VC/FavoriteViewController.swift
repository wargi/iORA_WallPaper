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

class FavoriteViewController: UIViewController {
   @IBOutlet private weak var collectionView: UICollectionView!
   
   override func viewWillAppear(_ animated: Bool) {
      
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
}

extension FavoriteViewController: UICollectionViewDelegate {
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
}


extension FavoriteViewController: UITabBarControllerDelegate
