//
//  DayCollectionViewCell.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/13.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
   static let identifier = "DayCollectionViewCell"
   @IBOutlet weak var dayLabel: UILabel!
   
   func configure(_ text: String) {
      dayLabel.text = text
      dayLabel.font = UIFont(name: "NanumSquareRoundB", size: 15)
   }
   
   override func prepareForReuse() {
      dayLabel.font = UIFont(name: "NanumSquareRoundB", size: 15)
   }
}
