//
//  WallPapeerCellCollectionViewCell.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/08.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Foundation
import RxSwift

class WallPaperCollectionViewCell: UICollectionViewCell {
   static let identifier = "WallPaperCollectionViewCell"
   var wallpaper: MyWallPaper?
   @IBOutlet weak var wallpaperImageView: UIImageView!
   @IBOutlet var activityIndicator: UIActivityIndicatorView!
   var bag = DisposeBag()
   
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
      if #available(iOS 13.0, *) {
         self.activityIndicator.style = .medium
      } else {
         self.activityIndicator.style = .gray
      }
   }

   func display(image: UIImage?) {
      wallpaperImageView.image = image
   }
   
   override func prepareForReuse() {
      wallpaperImageView.image = nil
      self.isHidden = false
   }
}
