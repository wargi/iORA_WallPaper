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
   var info: MyWallPaper?
   
   var isLoading: Bool {
      get { return activityIndicator.isAnimating }
      set {
         if newValue {
            activityIndicator.startAnimating()
         } else {
            activityIndicator.stopAnimating()
         }
      }
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
    shadow(offset: CGSize.init(width: 3, height: 3),
           color: UIColor.black.cgColor,
           radius: 4.0,
           opacity: 0.2)
    
      wallPaperImageView.layer.cornerRadius = 30
   }
   
   func display(image: UIImage?) {
      wallPaperImageView.image = image
   }
   
   func configure(info: MyWallPaper) {
      self.info = info

      guard let urlStr = PrepareForSetUp.shared.displayType == .retina ? info.wallpaper.imageType.retinaDeviceImageURL : info.wallpaper.imageType.superRetinaDeviceImageURL else { return }
      
      WallPapers.shared.favoriteSubject.subscribe(onNext:{
         if $0.contains(urlStr) {
            self.starButton.setImage(UIImage(named: "starM"), for: .normal)
         } else {
            self.starButton.setImage(UIImage(named: "star"), for: .normal)
         }
      })
         .disposed(by: rx.disposeBag)
   }
   
   @IBAction private func addFavoriteAction(_ sender: UIButton) {
      guard let wallpaper = info,
         let urlStr = PrepareForSetUp.shared.displayType == .retina ? wallpaper.wallpaper.imageType.retinaDeviceImageURL : wallpaper.wallpaper.imageType.superRetinaDeviceImageURL else { return }
      
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

extension UIView {
    func shadow(offset: CGSize, color: CGColor?, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
