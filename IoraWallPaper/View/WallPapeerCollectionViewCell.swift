//
//  WallPapeerCellCollectionViewCell.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/08.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Foundation

class WallPapeerCollectionViewCell: UICollectionViewCell {
   static let identifier = "WallPapeerCollectionViewCell"
   @IBOutlet private weak var wallpaperImageView: UIImageView!
   @IBOutlet var activityIndicator: UIActivityIndicatorView!
   
   func prepare(info: WallPaper) {
      DispatchQueue.main.async {
         self.activityIndicator.startAnimating()
      }
      guard let url = URL(string: info.imageURL) else { fatalError("invalid url") }
      let session = URLSession.shared
      DispatchQueue.global().async {
         let take = session.dataTask(with: url) { (data, resp, err) in
            if let err = err {
               print(err.localizedDescription)
            } else if let data = data {
               DispatchQueue.main.async {
                  self.activityIndicator.stopAnimating()
                  self.wallpaperImageView.image = UIImage(data: data)
               }
            }
         }
         
         take.resume()
      }
   }
   
   
}
