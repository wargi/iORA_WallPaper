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
   
   @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
      //사진 저장 한후
      if let error = error {
         print(error.localizedDescription)
      } else {
         print("success")
      }
   }
   
   @IBAction private func downloadAction(_ sender: UIButton) {
      guard let image = imageView.image else { return }

      UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
   }
   
   @IBAction private func closeAction(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
}
