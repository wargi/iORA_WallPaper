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
   
   func prepare(image: UIImage) {
      guard let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/iora-wallpaper.appspot.com/o/WallPaper%2FWallPaper003.png?alt=media&token=56a11d2a-d73f-4c0f-846d-08d1ec6ece5e") else { fatalError("invalid url") }
      let session = URLSession.shared
      DispatchQueue.global().async {
         let take = session.dataTask(with: url) { (data, resp, err) in
            if let err = err {
               print(err.localizedDescription)
            } else if let _ = data {
               DispatchQueue.main.async {
                  self.wallpaperImageView.image = image
               }
            }
         }
         
         take.resume()
      }
   }
}
