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
import Action

class SearchResultViewModel {
   let tag: Tag
   var title: Driver<String>
   let wallpapers: BehaviorSubject<[MyWallPaper]>
   var showDetailAction: Action<MyWallPaper, DetailImageViewModel> {
      return Action<MyWallPaper, DetailImageViewModel> { wallpaper in
         let viewModel = DetailImageViewModel(wallpapers: [wallpaper])
         
         return Observable.just(viewModel)
      }
   }
   
   init(tag: Tag) {
      self.tag = tag
      self.title = Observable.just(tag.info.name).asDriver(onErrorJustReturn: "")
      self.wallpapers = BehaviorSubject<[MyWallPaper]>(value: tag.result)
   }
}
