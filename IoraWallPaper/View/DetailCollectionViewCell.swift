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
   
   func configure(info: MyWallPaper) {
      wallPaperImageView.image = info.image

      self.layer.masksToBounds = false
      self.layer.shadowColor = UIColor.black.cgColor
      self.layer.shadowOpacity = 0.4
      self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
      self.layer.shadowRadius = 6
      self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                           cornerRadius: 30).cgPath
      
      wallPaperImageView.layer.cornerRadius = 30
      
      wallPaperImageView.layer.masksToBounds = true

      

      

   }
   
   override func prepareForReuse() {
      wallPaperImageView.image = nil
   }
}
