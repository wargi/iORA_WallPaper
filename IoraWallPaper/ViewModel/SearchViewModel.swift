//
//  SearchViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/25.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx
import Action

class SearchViewModel {
   var tags: Tags
   var list: [String]
   var filterd: BehaviorSubject<[String]>
   var searchResultAction: Action<String, SearchResultViewModel> {
      return Action<String, SearchResultViewModel> { tagName in
         guard let tag = WallPapers.shared.tags.list.first(where: { $0.info.name == tagName }) else { fatalError() }
         
         let viewModel = SearchResultViewModel(tag: tag)
         
         return Observable.just(viewModel)
      }
   }
   
   init(tags: Tags) {
      self.tags = tags
      self.list = tags.list.map { $0.info.name }
      self.filterd = BehaviorSubject<[String]>(value: list)
   }
}
