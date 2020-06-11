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
   var wallPaper: WallPaper?
   var image: UIImage?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      prepareImage()
   }
   
   func prepareImage() {
//      guard let info = wallPaper else { fatalError("Invalid WallPaper") }
      imageView.image = image
   }
   
   @IBAction private func closeAction(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
}
