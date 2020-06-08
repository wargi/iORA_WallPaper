//
//  WallPapeerCellCollectionViewCell.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/08.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class WallPapeerCollectionViewCell: UICollectionViewCell {
   static let identifier = "WallPapeerCollectionViewCell"
   @IBOutlet private weak var wallpaperImageView: UIImageView!
   
   func prepare(image: UIImage) {
      self.wallpaperImageView.image = image
   }
}
