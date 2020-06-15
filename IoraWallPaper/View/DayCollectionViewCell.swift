//
//  DayCollectionViewCell.swift
//  IoraWallPaper
//
//  Created by 박소정 on 2020/06/13.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
   static let identifier = "DayCollectionViewCell"
   @IBOutlet weak var dayLabel: UILabel!
   
   func setValue(text: String, textColor: UIColor) {
      dayLabel.text = text
      dayLabel.textColor = textColor
   }
}
