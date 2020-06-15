//
//  DetailViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/10.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Photos

class DetailImageViewController: UIViewController {
   @IBOutlet private weak var backButton: UIButton!
   @IBOutlet private weak var calendarButton: UIButton!
   @IBOutlet private weak var previewButton: UIButton!
   @IBOutlet private weak var saveButton: UIButton!
   @IBOutlet private weak var shareButton: UIButton!
   var image: UIImage?
   var brightness: Int?
   lazy var color: UIColor = {
      guard let brightness = brightness else { return .black }
      return brightness == 0 ? .white : .black
   }()
   
   @IBOutlet private weak var wallPaperImageView: UIImageView!
   override func viewDidLoad() {
      super.viewDidLoad()
      
      prepare()
   }
   
   func prepare() {
      guard let image = image else { fatalError("wall paper is invalid") }
      wallPaperImageView.image = image
      
      let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
      let calendarImage = UIImage(named: "calendar")?.withRenderingMode(.alwaysTemplate)
      let previewImage = UIImage(named: "preview")?.withRenderingMode(.alwaysTemplate)
      let downloadImage = UIImage(named: "download")?.withRenderingMode(.alwaysTemplate)
      let shareImage = UIImage(named: "share")?.withRenderingMode(.alwaysTemplate)
      
      backButton.imageView?.tintColor = color
      calendarButton.imageView?.tintColor = color
      previewButton.imageView?.tintColor = color
      saveButton.imageView?.tintColor = color
      shareButton.imageView?.tintColor = color
      
      backButton.setImage(backImage, for: .normal)
      calendarButton.setImage(calendarImage, for: .normal)
      previewButton.setImage(previewImage, for: .normal)
      saveButton.setImage(downloadImage, for: .normal)
      shareButton.setImage(shareImage, for: .normal)
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let showVC = segue.destination as? ShowPreViewController  {
         showVC.brightness = brightness
         showVC.image = image
      } else if let calVC = segue.destination as? CalendarViewController {
         calVC.brightness = brightness
         calVC.image = image
      }
   }
   
   @IBAction private func downlaodAction(_ sender: UIButton) {
      guard let image = image else { return }
      
      
      
      PHPhotoLibrary.shared().savePhoto(image: image, albumName: "iORA")
      
      let alert = UIAlertController(title: "Save Success :)", message: nil, preferredStyle: .alert)
      
      present(alert, animated: true) {
         self.dismiss(animated: true, completion: nil)
      }
   }
   
   @IBAction func popAction() {
      navigationController?.popViewController(animated: true)
   }
}
