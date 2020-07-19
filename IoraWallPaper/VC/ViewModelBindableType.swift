//
//  CommonViewModel.swift
//  IoraWallPaper
//
//  Created by 박소정 on 2020/07/19.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

protocol ViewModelBindableType {
   associatedtype ViewModelType
   
   var viewModel: ViewModelType! { get set }
   func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
   var storyboard: UIStoryboard {
      return UIStoryboard(name: "Main", bundle: nil)
   }
   
   mutating func bind(viewModel: Self.ViewModelType) {
      self.viewModel = viewModel
      loadViewIfNeeded()
      
      bindViewModel()
   }
}
