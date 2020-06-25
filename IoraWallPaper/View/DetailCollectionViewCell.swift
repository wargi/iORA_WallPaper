//
//  DetailCollectionViewCell.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/23.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
   static let identifier = "DetailCollectionViewCell"
   @IBOutlet weak var wallPaperImageView: UIImageView!
   @IBOutlet private weak var tagView: UIView!
   @IBOutlet private weak var tagLabel: UILabel!
   
   override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesEnded(touches, with: event)
      tagView.isHidden = !tagView.isHidden
   }
   
   func configure(info: MyWallPaper) {
      tagLabel.text = info.wallpaper.tag
      wallPaperImageView.image = info.image
   }
   
   override func prepareForReuse() {
      wallPaperImageView.image = nil
      tagView.isHidden = false
   }
}
