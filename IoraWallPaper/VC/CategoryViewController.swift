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
      collectionView.dataSource = self
      
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
      
   func bindViewModel() {
      viewModel.categorySubject
         .subscribe(onNext: {
            print($0)
            DispatchQueue.main.async {
               self.collectionView.reloadData()
            }
            
         })
         .disposed(by: rx.disposeBag)
      
   }
}

extension CategoryViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      print(WallPapers.shared.tags.list.count)
      return WallPapers.shared.tags.list.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier,
                                                          for: indexPath) as? CategoryCollectionViewCell else {
         fatalError("invalid CategoryCollectionViewCell")
      }
      let target = WallPapers.shared.tags.list[indexPath.item]
      cell.configure(category: target)
      
      return cell
   }
}

extension CategoryViewController: UICollectionViewDelegate {
}
