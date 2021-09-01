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

final class SearchViewModel: CommonViewModel {
    var tags: [Tag]
    var list: [String]
    var filterd: BehaviorSubject<[String]>
    func showSearchResult(tagName: String) -> SearchResultViewController? {
        guard let tag = WallPapers.shared.tags.first(where: { $0.info.name == tagName }),
              var searchResultVC = self.storyboard.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as? SearchResultViewController else { return nil }
        
        let viewModel = SearchResultViewModel(tag: tag)
        searchResultVC.bind(viewModel: viewModel)
        
        return searchResultVC
    }
    
    init(tags: [Tag]) {
        self.tags = tags
        self.list = tags.map { $0.info.name }
        self.filterd = BehaviorSubject<[String]>(value: list)
    }
}
