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
      
      setCollectionView()
   }
   
   
   
   func setCollectionView() {
      WallPapers.shared.favoriteSubject
         .bind(to: collectionView.rx.items(cellIdentifier: FavoriteWallpaperCollectionViewCell.identifier,
                                           cellType: FavoriteWallpaperCollectionViewCell.self)) { index, urlStr, cell in
                                             cell.configure(urlString: urlStr)
      }
      .disposed(by: rx.disposeBag)
   }
   
   func bindViewModel() {
      if let tabbar = self.tabBarController as? CustomTabbarController{
         tabbar.coordinator = viewModel.sceneCoordinator
      }

   }
}

extension FavoriteViewController: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      self.collectionView.deselectItem(at: IndexPath(item: indexPath.item, section: 0), animated: true)
      var result: [MyWallPaper]
      let index = indexPath.item
      
      result = WallPapers.shared.myWallPapers.filter {
         let displayType = PrepareForSetUp.shared.displayType
         let target = $0.wallpaper.imageType
         guard let urlStr = displayType == .retina ? target.retinaDeviceImageURL : target.superRetinaDeviceImageURL else {
            return false
         }
         
         return WallPapers.shared.favoriteArr.contains(urlStr)
      }
      
      let temp = index + 9 < result.count ? result[index ... index + 9] : result[index...]
      result = Array(temp)
      
   }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      let collectionWidth = self.collectionView.bounds.width - 30
      
      let width = collectionWidth / 2
      let height = PrepareForSetUp.shared.displayType == .retina ? width * 1.77 : width * 2.16
      
      return CGSize(width: width, height: height)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 10
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 10
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
   }
}
