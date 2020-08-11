//
//  FavoriteWallpaperCollectionViewCell.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/17.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class FavoriteWallpaperCollectionViewCell: UICollectionViewCell {
   static let identifier = "FavoriteWallpaperCollectionViewCell"
   @IBOutlet weak var wallpaperImageView: UIImageView!
   @IBOutlet var activityIndicator: UIActivityIndicatorView!
   var targetUrlStr: String?
   
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
      
      self.layer.cornerRadius = 15
      self.layer.borderWidth = 0.1
      self.layer.borderColor = UIColor.lightGray.cgColor
   }
   
   func display(image: UIImage?) {
      wallpaperImageView.image = image
   }
   
   override func prepareForReuse() {
      wallpaperImageView.image = nil
   }
}
