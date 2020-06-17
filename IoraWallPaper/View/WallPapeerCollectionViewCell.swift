//
//  WallPapeerCellCollectionViewCell.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/08.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Foundation

class WallPapeerCollectionViewCell: UICollectionViewCell {
   static let identifier = "WallPapeerCollectionViewCell"
   @IBOutlet weak var wallpaperImageView: UIImageView!
   @IBOutlet var activityIndicator: UIActivityIndicatorView!
   
   func shadow() {
      contentView.layer.cornerRadius = 5
      contentView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
      contentView.layer.masksToBounds = true
      contentView.layer.shadowColor = UIColor.black.cgColor
      contentView.layer.shadowOffset = CGSize(width: 1, height: 2)
      contentView.layer.shadowOpacity = 0.3
      contentView.layer.shadowRadius = 0.5
   }
   
   func configure(itemAt: Int) {
      isUserInteractionEnabled = false
      self.activityIndicator.startAnimating()
      
      
      
      WallPapers.shared.imageDownload(index: itemAt) { image in
         DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.wallpaperImageView.image = image
            self.isUserInteractionEnabled = true
            self.shadow()
         }
      }
   }
   
   override func prepareForReuse() {
      wallpaperImageView.image = nil
//      shadow()
   }   
}
