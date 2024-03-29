//
//  FavoriteViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/11.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation

final class FavoriteViewModel: CommonViewModel {
   func showDetailVC(wallpapers: [MyWallPaper]) -> DetailImageViewController? {
      guard var detailImageVC = storyboard.instantiateViewController(withIdentifier: DetailImageViewController.identifier) as? DetailImageViewController else { return nil }
      
      let viewModel = DetailImageViewModel(wallpapers: wallpapers)
      detailImageVC.bind(viewModel: viewModel)
      
      return detailImageVC
   }
}
