//
//  DetailCollectionViewCell.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/23.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class DetailCollectionViewCell: UICollectionViewCell {
   static let identifier = "DetailCollectionViewCell"
   @IBOutlet weak var wallPaperImageView: UIImageView!
   @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
   @IBOutlet private weak var starButton: UIButton!
   private var info: MyWallPaper?
   
   func configure(info: MyWallPaper) {
      self.info = info
      layer.masksToBounds = false
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.4
      layer.shadowOffset = CGSize(width: 0, height: 1.0)
      layer.shadowRadius = 6
      layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                      cornerRadius: 30).cgPath
      wallPaperImageView.layer.cornerRadius = 30
      
      guard let deviceType = PrepareForSetUp.shared.displayType,
         let urlStr = deviceType == .retina ? info.wallpaper.imageType.retinaDeviceImageURL : info.wallpaper.imageType.superRetinaDeviceImageURL else {
            fatalError("invalid favoriteArr")
      }
      
      WallPapers.shared.favoriteSubject.subscribe(onNext:{
         if $0.contains(urlStr) {
            self.starButton.setImage(UIImage(named: "starM"), for: .normal)
         } else {
            self.starButton.setImage(UIImage(named: "star"), for: .normal)
         }
      })
         .disposed(by: rx.disposeBag)

      if let image = info.image {
         wallPaperImageView.image = image
      } else {
         self.activityIndicator.startAnimating()
         PrepareForSetUp.shared.imageDownload(info: info) { image in
            DispatchQueue.main.async {
               self.activityIndicator.stopAnimating()
               self.wallPaperImageView.image = image
            }
         }
      }
   }
   
   @IBAction private func addFavoriteAction(_ sender: UIButton) {
      guard let wallpaper = info,
         let displayType = PrepareForSetUp.shared.displayType,
         let urlStr = displayType == .retina ? wallpaper.wallpaper.imageType.retinaDeviceImageURL : wallpaper.wallpaper.imageType.superRetinaDeviceImageURL else { return }
      
      var favArr = WallPapers.shared.favoriteArr
      
      if let index = favArr.firstIndex(of: urlStr) {
         starButton.setImage(UIImage(named: "star"), for: .normal)
         favArr.remove(at: index)
         WallPapers.shared.favoriteArr = favArr
         WallPapers.shared.favoriteSubject.onNext(favArr)
      } else {
         starButton.setImage(UIImage(named: "starM"), for: .normal)
         favArr.append(urlStr)
         WallPapers.shared.favoriteArr = favArr
         WallPapers.shared.favoriteSubject.onNext(favArr)
      }
      
      UserDefaults.standard.set(favArr, forKey: "favoriteArr")
   }
   
   override func prepareForReuse() {
      starButton.setImage(UIImage(named: "starM"), for: .normal)
      wallPaperImageView.image = nil
   }
}
