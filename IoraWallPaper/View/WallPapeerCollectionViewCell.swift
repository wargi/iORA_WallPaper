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
//
//   func configure(at index: Int) {
//      isUserInteractionEnabled = false
//      self.activityIndicator.startAnimating()
//
//      WallPapers.shared.imageDownload(at: index) {
//         DispatchQueue.main.async {
//            self.activityIndicator.stopAnimating()
//         }
//      }
//   }
//
//   override func prepareForReuse() {
//      wallpaperImageView.image = nil
//   }
}
