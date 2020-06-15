//
//  ShowPreViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/11.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Photos

class ShowPreViewController: UIViewController {
   @IBOutlet private weak var imageView: UIImageView!
   @IBOutlet private weak var closeButton: UIButton!
   @IBOutlet private weak var downloadButton: UIButton!
   @IBOutlet private weak var displayTimeLabel: UILabel!
   @IBOutlet private weak var displayDateLabel: UILabel!
   var brightness: Int?
   var image: UIImage?
   lazy var color: UIColor = {
      guard let brightness = brightness else { return .black }
      return brightness == 0 ? .white : .black
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setImageAndTintColor()
   }
   
   func setImageAndTintColor() {
      guard let image = image else { return }
      imageView.image = image
      
      let closeImage = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
      let downImage = UIImage(named: "pDownload")?.withRenderingMode(.alwaysTemplate)
      
      closeButton.imageView?.tintColor = color
      downloadButton.imageView?.tintColor = color
      displayTimeLabel.textColor = color
      displayDateLabel.textColor = color
      
      closeButton.setImage(closeImage, for: .normal)
      downloadButton.setImage(downImage, for: .normal)
   }
   
   @IBAction private func downloadAction(_ sender: UIButton) {
      guard let image = imageView.image else { return }

      PHPhotoLibrary.shared().savePhoto(image: image, albumName: "iORA")
      
      let alert = UIAlertController(title: "Save Success :)", message: nil, preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default) { (_) in
         self.dismiss(animated: true, completion: nil)
      }
      alert.addAction(action)
      
      present(alert, animated: true, completion: nil)
   }
   
   @IBAction private func closeAction(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
}
