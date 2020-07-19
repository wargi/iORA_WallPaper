//
//  SearchResultViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/25.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultViewModel: CommonViewModel {
   let tag: Tag
   var title: Driver<String>
   let wallpapers: BehaviorSubject<[MyWallPaper]>
   
   func showDetailVC(wallpaper: MyWallPaper) -> DetailImageViewController {
      guard var detailImageVC = storyboard.instantiateViewController(withIdentifier: DetailImageViewController.identifier) as? DetailImageViewController else { fatalError("Not Created ShowDetailVC") }
      
      let viewModel = DetailImageViewModel(wallpapers: [wallpaper])
      detailImageVC.bind(viewModel: viewModel)
      
      return detailImageVC
      
   }
   
   init(tag: Tag) {
      self.tag = tag
      self.title = Observable.just(tag.info.name).asDriver(onErrorJustReturn: "")
      self.wallpapers = BehaviorSubject<[MyWallPaper]>(value: tag.result)
   }
}
