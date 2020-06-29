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
   @IBOutlet weak var dimmingView: UIView!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var contentLabel: UILabel!

   func configure(info: MyWallPaper) {
      isUserInteractionEnabled = false
      self.activityIndicator.startAnimating()
      
      WallPapers.shared.imageDownload(info: info) { image in
         DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.wallpaperImageView.image = image
            self.isUserInteractionEnabled = true
         }
      }
   }
   
   func tagConfigure(title: String?, isHidden: Bool) {
      titleLabel.text = title
//      contentLabel.text =
      dimmingView.isHidden = isHidden
   }
   
   override func prepareForReuse() {
      wallpaperImageView.image = nil
      titleLabel.text = nil
//      contentLabel.text = nil
      dimmingView.isHidden = true
   }   
}
