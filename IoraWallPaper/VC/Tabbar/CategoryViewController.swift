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
import NSObject_Rx

class CategoryViewController: UIViewController {
   var viewModel = CategoryViewModel()
   @IBOutlet private weak var collectionView: UICollectionView!
   
   var imageOperations: [IndexPath: ImageLoadOpertaion] = [:]
   var downloadQueue = OperationQueue()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
         let collectionViewSize = UIScreen.main.bounds
         layout.minimumLineSpacing = 30
         layout.minimumInteritemSpacing = 0
         
         if PrepareForSetUp.shared.displayType == .retina {
            let width = collectionViewSize.width * 0.78
            layout.itemSize = CGSize(width: width, height: width * 1.77)
         } else {
            let width = collectionViewSize.width * 0.78
            layout.itemSize = CGSize(width: width, height: width * 2.16)
         }
      }
      
      bindViewModel()
   }
      
   func bindViewModel() {
      viewModel.categorySubject
         .bind(to: collectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.identifier,
                                           cellType: CategoryCollectionViewCell.self)) { item, tag, cell in
                                             cell.configure(category: tag)
         }
         .disposed(by: rx.disposeBag)
      
      collectionView.rx.itemSelected
         .do(onNext: {
            self.collectionView.deselectItem(at: $0, animated: false)
         })
         .map { self.viewModel.showDetailVC(item: $0.item) }
         .subscribe(onNext: { [weak self] opVC in
            guard let strongSelf = self,
                  let vc = opVC else { return }
            strongSelf.navigationController?.pushViewController(vc, animated: true)
         })
         .disposed(by: rx.disposeBag)
   }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      guard let cell = cell as? CategoryCollectionViewCell,
         let target = cell.category,
         let url = PrepareForSetUp.getImageURL(info: target.result[0]),
         cell.imageView.image == nil else { return }
      
      let imageOp = ImageLoadOpertaion(url: url) { (image) in
         DispatchQueue.main.async {
            cell.display(image: image)
         }
      }
      
      downloadQueue.addOperation(imageOp)
      imageOperations.updateValue(imageOp, forKey: indexPath)
   }
   
   func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      if let op = imageOperations[indexPath] {
         op.cancel()
         imageOperations.removeValue(forKey: indexPath)
      }
   }
}
