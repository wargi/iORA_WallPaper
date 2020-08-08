//
//  CategoryCollectionViewCell.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/13.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift

class CategoryCollectionViewCell: UICollectionViewCell {
   static let identifier = "CategoryCollectionViewCell"
   var category: Tag?
   @IBOutlet weak var imageView: UIImageView!
   @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
   @IBOutlet private weak var titleLabel: UILabel!
   @IBOutlet private weak var contentLabel: UILabel!
   
   
   var isLoading: Bool {
      get { return activityIndicator.isAnimating }
      set {
         if newValue {
            activityIndicator.startAnimating()
         } else {
            activityIndicator.stopAnimating()
         }
      }
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      layer.cornerRadius = 25
   }
   
   func display(image: UIImage?) {
      imageView.image = image
   }
   
   func configure(category: Tag) {
      self.category = category
      titleLabel.text = category.info.name
      contentLabel.text = category.info.desc
   }
}
