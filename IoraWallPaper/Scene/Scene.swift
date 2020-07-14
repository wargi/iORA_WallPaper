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
      
      switch self {
      case .initialLaunch(let viewModel):
         guard var initialLaunchVC = storyboard.instantiateViewController(withIdentifier: "initialLaunchVC") as? InitialLaunchViewController else { fatalError("invalid initialLaunchVC") }
         
         initialLaunchVC.bind(viewModel: viewModel)
         
         return initialLaunchVC
      case .main(let viewModel):
         guard let mainTabbar = storyboard.instantiateViewController(withIdentifier: "CustomTabbarController") as? CustomTabbarController,
            let mainNav = mainTabbar.viewControllers?.first as? UINavigationController,
            var mainVC = mainNav.viewControllers.first as? MainViewController else { fatalError("invalid mainVC") }
         
         mainTabbar.view.tag = 0
         mainVC.bind(viewModel: viewModel)
         
         return mainNav
      case .favorite(let viewModel):
         guard let mainTabbar = storyboard.instantiateViewController(withIdentifier: "CustomTabbarController") as? CustomTabbarController,
            let favoriteNav = mainTabbar.viewControllers?[1] as? UINavigationController,
            var favoriteVC = favoriteNav.viewControllers.first as? FavoriteViewController else { fatalError("invalid favoriteVC") }
         
         mainTabbar.view.tag = 1
         favoriteVC.bind(viewModel: viewModel)
         
         return favoriteNav
      case .category(let viewModel):
         guard let mainTabbar = storyboard.instantiateViewController(withIdentifier: "CustomTabbarController") as? CustomTabbarController,
            let categoryNav = mainTabbar.viewControllers?[2] as? UINavigationController,
            var categoryVC = categoryNav.viewControllers.first as? CategoryViewController else { fatalError("invalid categoryVC") }
         
         mainTabbar.view.tag = 2
         categoryVC.bind(viewModel: viewModel)
         
         return categoryNav
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
