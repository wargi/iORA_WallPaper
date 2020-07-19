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

class SearchViewModel: CommonViewModel {
   var tags: Tags
   var list: [String]
   var filterd: BehaviorSubject<[String]>
   func showSearchResult(tagName: String) -> SearchResultViewController {
      guard let tag = WallPapers.shared.tags.list.first(where: { $0.info.name == tagName }),
         var searchResultVC = self.storyboard.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as? SearchResultViewController else { fatalError() }
      
      let viewModel = SearchResultViewModel(tag: tag)
      searchResultVC.bind(viewModel: viewModel)
      
      return searchResultVC
   }
   
   init(tags: Tags) {
      self.tags = tags
      self.list = tags.list.map { $0.info.name }
      self.filterd = BehaviorSubject<[String]>(value: list)
   }
}
