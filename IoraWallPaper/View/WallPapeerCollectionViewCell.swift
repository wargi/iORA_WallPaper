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

class WallPapeerCollectionViewCell: UICollectionViewCell {
   static let identifier = "WallPapeerCollectionViewCell"
   @IBOutlet weak var wallpaperImageView: UIImageView!
   @IBOutlet var activityIndicator: UIActivityIndicatorView!
   @IBOutlet weak var dimmingView: UIView!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var contentLabel: UILabel!
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
   
   func tagConfigure(info: TagInfo?, isHidden: Bool) {
      titleLabel.text = info?.name
      contentLabel.text = info?.desc
      dimmingView.isHidden = isHidden
   }
   
   override func prepareForReuse() {
      self.layer.cornerRadius = 15
      
      wallpaperImageView.image = nil
      titleLabel.text = nil
      contentLabel.text = nil
      dimmingView.isHidden = true
      
      bag = DisposeBag()
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      self.layer.cornerRadius = 15
      self.layer.borderWidth = 0.1
      self.layer.borderColor = UIColor.lightGray.cgColor
   }
   
   required init?(coder: NSCoder) {
      super.init(coder: coder)
      
      self.layer.cornerRadius = 15
      self.layer.borderWidth = 0.1
      self.layer.borderColor = UIColor.lightGray.cgColor
   }
}
