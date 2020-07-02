//
//  Scene.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/26.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

enum Scene {
   case main(MainViewModel)
   case detailImage(DetailImageViewModel)
   case showPre(ShowPreViewModel)
   case calendar(CalendarViewModel)
   case search(SearchViewModel)
   case searchResult(SearchResultViewModel)
}

extension Scene {
   func instantiate(from stroyboard: String = "Main") -> UIViewController {
      let storyboard = UIStoryboard(name: stroyboard, bundle: nil)
      guard let nav = storyboard.instantiateViewController(withIdentifier: "MainNav") as? UINavigationController else { fatalError("invalid nav") }
      
      switch self {
      case .main(let viewModel):
         guard var mainVC = nav.viewControllers.first as? MainViewController else { fatalError("invalid mainVC") }
         
         mainVC.bind(viewModel: viewModel)
         
         return nav
      case .detailImage(let viewModel):
         guard var detailImageVC = nav.viewControllers.filter({ $0 is DetailImageViewController }).first as? DetailImageViewController else { fatalError("invalid detailImageVC") }
         
         detailImageVC.bind(viewModel: viewModel)
         
         return detailImageVC
      case .showPre(let viewModel):
         guard var showPreVC = storyboard.instantiateViewController(withIdentifier: "ShowPreVC") as? ShowPreViewController else { fatalError("invalid showPre") }
         
         showPreVC.bind(viewModel: viewModel)
         
         return showPreVC
      case .calendar(let viewModel):
         guard var calendarVC = storyboard.instantiateViewController(withIdentifier: "CalendarVC") as? CalendarViewController else { fatalError("invalid calendar") }
         
         calendarVC.bind(viewModel: viewModel)
         
         return calendarVC
      case .search(let viewModel):
         guard var searchVC = storyboard.instantiateViewController(withIdentifier: "searchVC") as? SearchViewController else { fatalError("invalid searchVC") }
         
         searchVC.bind(viewModel: viewModel)
         
         return searchVC
      case .searchResult(let viewModel):
         guard var searchResultVC = storyboard.instantiateViewController(withIdentifier: "searchResultVC") as? SearchResultViewController else { fatalError("invalid searchResultVC") }
         
         searchResultVC.bind(viewModel: viewModel)
         
         return searchResultVC
      }
   }
}
