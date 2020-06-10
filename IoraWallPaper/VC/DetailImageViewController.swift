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
   @IBOutlet private weak var wallPaperImageView: UIImageView!
   override func viewDidLoad() {
      super.viewDidLoad()
      
      wallPaperImageView.image = image
   }
   
   @IBAction func popAction() {
      navigationController?.popViewController(animated: true)
   }
}
