//
//  BannerCollectionViewCell.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/30.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
   static let identifier = "BannerCollectionViewCell"
   @IBOutlet private weak var imageView: UIImageView!
   
   func configure(image: UIImage?) {
      imageView.image = image
   }
}
