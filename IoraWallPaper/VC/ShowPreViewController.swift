//
//  ShowPreViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/11.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class ShowPreViewController: UIViewController {
   @IBOutlet private weak var imageView: UIImageView!
   @IBOutlet private weak var closeButton: UIButton!
   @IBOutlet private weak var downloadButton: UIButton!
   @IBOutlet private weak var displayTimeLabel: UILabel!
   @IBOutlet private weak var displayDateLabel: UILabel!
   var wallPaper: WallPaper?
   var image: UIImage?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      prepareImage()
   }
   
   func prepareImage() {
//      guard let info = wallPaper else { fatalError("Invalid WallPaper") }
      imageView.image = image
      
      let closeImage = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
      let downImage = UIImage(named: "pDownload")?.withRenderingMode(.alwaysTemplate)
      
      if wallPaper?.brightness == 0 {
         closeButton.imageView?.tintColor = .white
         downloadButton.imageView?.tintColor = .white
         displayTimeLabel.textColor = .white
         displayDateLabel.textColor = .white
      } else {
         closeButton.imageView?.tintColor = .black
         downloadButton.imageView?.tintColor = .black
         displayTimeLabel.textColor = .black
         displayDateLabel.textColor = .black
      }
      
      closeButton.setImage(closeImage, for: .normal)
      downloadButton.setImage(downImage, for: .normal)
   }
   
   @IBAction private func closeAction(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
}
