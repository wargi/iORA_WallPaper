//
//  CategoryViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/11.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class CategoryViewModel: CommonViewModel {
   let disposedBag = DisposeBag()
   var categories: [Tag]
   var categorySubject: BehaviorSubject<[Tag]>

   func showDetailVC(item: Int) -> DetailImageViewController {
      let target = categories[item].result
      guard var detailImageVC = storyboard.instantiateViewController(withIdentifier: DetailImageViewController.identifier) as? DetailImageViewController else { fatalError("Not Created ShowDetailVC") }
      
      let viewModel = DetailImageViewModel(wallpapers: target)
      detailImageVC.bind(viewModel: viewModel)
      
      return detailImageVC
   }
   
   func setCategory() {
      WallPapers.shared.tagSubject
         .subscribe(onNext: {
            self.categories = $0
            self.categorySubject.onNext($0)
         })
         .disposed(by: disposedBag)
   }
   
   override init() {
      self.categories = WallPapers.shared.tags
      self.categorySubject = BehaviorSubject<[Tag]>(value: [])
      
      super.init()
      
      setCategory()
   }
}
