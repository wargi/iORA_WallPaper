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
   @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
   @IBOutlet private weak var imageView: UIImageView!
   @IBOutlet private weak var titleLabel: UILabel!
   @IBOutlet private weak var contentLabel: UILabel!
   
   func configure(category: Tag) {
      self.layer.cornerRadius = 25
      titleLabel.text = category.info.name
      contentLabel.text = category.info.desc
      
      if let image = category.result[0].image {
         imageView.image = image
      } else {
         isUserInteractionEnabled = false
         self.activityIndicator.startAnimating()
         PrepareForSetUp.shared.imageDownload(info: category.result[0]) { (image) in
            DispatchQueue.main.async {
               self.activityIndicator.stopAnimating()
               self.imageView.image = image
               self.isUserInteractionEnabled = true
            }
         }
      }
   }
   
   override func prepareForReuse() {
      self.layer.cornerRadius = 25
   }
}
