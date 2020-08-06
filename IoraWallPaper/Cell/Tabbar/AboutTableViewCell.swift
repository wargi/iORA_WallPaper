//
//  AboutTableViewCell.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/23.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class AboutTableViewCell: UITableViewCell {
   static let identifier = "AboutTableViewCell"
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var linkLabel: UILabel!
   @IBOutlet weak var thumnailImageView: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
