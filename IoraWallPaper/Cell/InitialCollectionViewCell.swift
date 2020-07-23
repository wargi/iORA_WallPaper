//
//  InitialCollectionViewCell.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/28.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class InitialCollectionViewCell: UICollectionViewCell {
   static let identifier = "InitialCollectionViewCell"
   @IBOutlet private weak var imageView: UIImageView!
   
   func configure(image: UIImage?) {
      guard let image = image else { return }
      
      imageView.image = image
   }
   
   override func prepareForReuse() {
      imageView.image = nil
   }
}
