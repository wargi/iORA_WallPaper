//
//  ViewModelBindableType.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/25.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

protocol ViewModelBindableType {
   associatedtype ViewModelType
   
   var viewModel: ViewModelType! { get set }
   func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
   mutating func bind(viewModel: Self.ViewModelType) {
      self.viewModel = viewModel
      loadViewIfNeeded()
      
      bindViewModel()
   }
}
