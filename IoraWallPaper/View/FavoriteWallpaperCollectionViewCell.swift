//
//  FavoriteWallpaperCollectionViewCell.swift
//  IoraWallPaper
//
//  Created by 박소정 on 2020/07/17.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class FavoriteWallpaperCollectionViewCell: UICollectionViewCell {
   static let identifier = "FavoriteWallpaperCollectionViewCell"
   @IBOutlet weak var wallpaperImageView: UIImageView!
   @IBOutlet var activityIndicator: UIActivityIndicatorView!
   
   func configure(urlString: String) {
      self.layer.cornerRadius = 15
      self.layer.borderWidth = 0.1
      self.layer.borderColor = UIColor.lightGray.cgColor
      
      guard wallpaperImageView.image == nil else { return }
      activityIndicator.startAnimating()
      
      if let wallpaper = WallPapers.shared.myWallPapers.first(where: {
         if urlString == $0.wallpaper.imageType.retinaDeviceImageURL || urlString == $0.wallpaper.imageType.superRetinaDeviceImageURL {
            return true
         }
         return false
      }) {
         if let image = wallpaper.image {
            self.wallpaperImageView.image = image
            self.activityIndicator.stopAnimating()
         } else {
            imageDownload(urlString: urlString)
            wallpaper.image = wallpaperImageView.image
         }
      } else {
         imageDownload(urlString: urlString)
      }
   }
   
   private func imageDownload(urlString: String) {
      guard let url = URL(string: urlString) else { return }
      
      let config = URLSessionConfiguration.default
      config.requestCachePolicy = .returnCacheDataElseLoad
      
      let session = URLSession.init(configuration: config)
      
      let task = session.dataTask(with: url) { data, response, err in
         if let error = err {
            print(error.localizedDescription)
            return
         }
         
         if let data = data, let image = UIImage(data: data) {
            DispatchQueue.main.async {
               self.wallpaperImageView.image = image
               self.activityIndicator.stopAnimating()
            }
         }
      }
      
      task.resume()
   }
   
   override func prepareForReuse() {
      self.layer.cornerRadius = 15
      self.layer.borderWidth = 0.1
      self.layer.borderColor = UIColor.lightGray.cgColor
      
      wallpaperImageView.image = nil
   }
}
