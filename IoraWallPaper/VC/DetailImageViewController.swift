//
//  DetailViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/10.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController {
   var image: UIImage?
   var wallPaper: WallPaper?
   @IBOutlet private weak var backButton: UIButton!
   @IBOutlet private weak var saveButton: UIButton!
   @IBOutlet private weak var previewButton: UIButton!
   @IBOutlet private weak var shareButton: UIButton!
   
   @IBOutlet private weak var wallPaperImageView: UIImageView!
   override func viewDidLoad() {
      super.viewDidLoad()
      
      prepare()
   }
   
   func prepare() {
      guard let info = wallPaper else { fatalError("wall paper is invalid") }
      wallPaperImageView.image = image
      
      let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
      let previewImage = UIImage(named: "preview")?.withRenderingMode(.alwaysTemplate)
      let downloadImage = UIImage(named: "download")?.withRenderingMode(.alwaysTemplate)
      let shareImage = UIImage(named: "share")?.withRenderingMode(.alwaysTemplate)
      
      if info.brightness == 0 {
         backButton.imageView?.tintColor = .white
         saveButton.imageView?.tintColor = .white
         previewButton.imageView?.tintColor = .white
         shareButton.imageView?.tintColor = .white
      } else {
         backButton.imageView?.tintColor = .black
         saveButton.imageView?.tintColor = .black
         previewButton.imageView?.tintColor = .black
         shareButton.imageView?.tintColor = .black
      }
      
      backButton.setImage(backImage, for: .normal)
      previewButton.setImage(previewImage, for: .normal)
      saveButton.setImage(downloadImage, for: .normal)
      shareButton.setImage(shareImage, for: .normal)
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      guard let showVC = segue.destination as? ShowPreViewController else { return }
      showVC.wallPaper = wallPaper
      showVC.image = image
   }
   
   @IBAction func popAction() {
      navigationController?.popViewController(animated: true)
   }
}
