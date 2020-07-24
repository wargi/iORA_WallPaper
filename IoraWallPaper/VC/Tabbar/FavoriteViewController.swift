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
import NSObject_Rx

class FavoriteViewController: UIViewController {
   @IBOutlet private weak var collectionView: UICollectionView!
   @IBOutlet private weak var emptyView: UIView!
   var viewModel = FavoriteViewModel()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
         layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
         layout.minimumLineSpacing = 10
         layout.minimumInteritemSpacing = 10
         
         let screenWidth = UIScreen.main.bounds.size.width - 30
         let width = screenWidth / 2
         let height = PrepareForSetUp.shared.displayType == .retina ? width * 1.77 : width * 2.16
         
         layout.itemSize = CGSize(width: width, height: height)
      }
      
      bindViewModel()
   }
   
   func bindViewModel() {
      WallPapers.shared.favoriteSubject
         .map { return $0.count != 0 }
         .subscribe(onNext: {
            self.emptyView.isHidden = $0
         })
         .disposed(by: rx.disposeBag)
      
      WallPapers.shared.favoriteSubject
         .bind(to: collectionView.rx.items(cellIdentifier: FavoriteWallpaperCollectionViewCell.identifier,
                                           cellType: FavoriteWallpaperCollectionViewCell.self)) { index, urlStr, cell in
                                             cell.configure(urlString: urlStr)
      }
      .disposed(by: rx.disposeBag)
      
      Observable.zip(collectionView.rx.modelSelected(String.self), collectionView.rx.itemSelected)
         .do(onNext: {
            self.collectionView.deselectItem(at: $0.1, animated: false)
         })
         .map {
            let displayType = PrepareForSetUp.shared.displayType
            var result: [MyWallPaper]
            let index = $0.1.item
            
            result = WallPapers.shared.favoriteArr.map { urlStr in
               guard let wallpaper = WallPapers.shared.myWallPapers.first(where: {
                  let target = $0.wallpaper.imageType
                  guard let urlString = displayType == .retina ? target.retinaDeviceImageURL : target.superRetinaDeviceImageURL else {
                     return false
                  }
                  return urlStr == urlString
               }) else { fatalError() }
               return wallpaper
            }
            let temp = index + 9 < result.count ? result[index ... index + 9] : result[index...]
            return Array(temp)
      }
      .map { self.viewModel.showDetailVC(wallpapers: $0) }
      .subscribe(onNext: {
         self.navigationController?.pushViewController($0, animated: true)
      })
         .disposed(by: rx.disposeBag)
      
   }
}

extension FavoriteViewController: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      self.collectionView.deselectItem(at: IndexPath(item: indexPath.item, section: 0), animated: true)
      
   }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
   
}
