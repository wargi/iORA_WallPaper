//
//  Scene.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/26.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

enum Scene {
   case initialLaunch(InitialLaunchViewModel)
   case main(MainViewModel)
   case favorite(FavoriteViewModel)
   case category(CategoryViewModel)
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
      case .initialLaunch(let viewModel):
         guard var initialLaunchVC = storyboard.instantiateViewController(withIdentifier: "initialLaunchVC") as? InitialLaunchViewController else { fatalError("invalid initialLaunchVC") }
         
         initialLaunchVC.bind(viewModel: viewModel)
         
         return initialLaunchVC
      case .main(let viewModel):
         guard let mainTabbar = nav.viewControllers.first as? CustomTabbarController,
            var mainVC = mainTabbar.viewControllers?.first as? MainViewController else { fatalError("invalid mainVC") }
         
         mainVC.bind(viewModel: viewModel)
         
         return nav
      case .favorite(let viewModel):
         guard var favoriteVC = storyboard.instantiateViewController(withIdentifier: "favoriteVC") as? FavoriteViewController else { fatalError("invalid favoriteVC") }
         
         favoriteVC.bind(viewModel: viewModel)
         
         return favoriteVC
      case .category(let viewModel):
         guard var categoryVC = storyboard.instantiateViewController(withIdentifier: "categoryVC") as? CategoryViewController else { fatalError("invalid categoryVC") }
         
         categoryVC.bind(viewModel: viewModel)
         
         return categoryVC
      case .detailImage(let viewModel):
         guard var detailImageVC = storyboard.instantiateViewController(withIdentifier: "detailImageVC") as? DetailImageViewController else { fatalError("invalid detailImageVC") }
         
         detailImageVC.bind(viewModel: viewModel)
         
         return detailImageVC
      case .showPre(let viewModel):
         guard var showPreVC = storyboard.instantiateViewController(withIdentifier: "ShowPreVC") as? ShowPreViewController else { fatalError("invalid showPre") }
         
         showPreVC.bind(viewModel: viewModel)
         
         return showPreVC
      case .calendar(let viewModel):
         guard var calendarVC = storyboard.instantiateViewController(withIdentifier: "calendarVC") as? CalendarViewController else { fatalError("invalid calendar") }
         
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
