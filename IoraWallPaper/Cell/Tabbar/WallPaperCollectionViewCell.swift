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
   @IBOutlet weak var wallpaperImageView: UIImageView!
   @IBOutlet var activityIndicator: UIActivityIndicatorView!
   var bag = DisposeBag()

   func configure(info: MyWallPaper) {
      isUserInteractionEnabled = false
      self.activityIndicator.startAnimating()
      
      PrepareForSetUp.shared.imageDownload(info: info) { image in
         DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.wallpaperImageView.image = image
            self.isUserInteractionEnabled = true
         }
      }
   }
   
   override func prepareForReuse() {
      self.layer.cornerRadius = 15
      
      wallpaperImageView.image = nil
      self.isHidden = false
      
      bag = DisposeBag()
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      self.layer.cornerRadius = 15
      self.layer.borderWidth = 0.1
      self.layer.borderColor = UIColor.lightGray.cgColor
      if #available(iOS 13.0, *) {
         self.activityIndicator.style = .medium
      } else {
         self.activityIndicator.style = .gray
      }
   }
   
   required init?(coder: NSCoder) {
      super.init(coder: coder)
      
      self.layer.cornerRadius = 15
      self.layer.borderWidth = 0.1
      self.layer.borderColor = UIColor.lightGray.cgColor
   }
}
