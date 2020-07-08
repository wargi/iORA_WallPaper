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
   @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
   
   override init(frame: CGRect) {
      super.init(frame: frame)
   }
   
   required init?(coder: NSCoder) {
      super.init(coder: coder)
   }
   
   func configure(info: MyWallPaper) {
      wallPaperImageView.image = info.image
      self.activityIndicator.startAnimating()
      
      PrepareForSetUp.shared.imageDownload(info: info) { image in
         DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.wallPaperImageView.image = image
         }
      }
   }
   
   override func prepareForReuse() {
      wallPaperImageView.image = nil
   }
}
