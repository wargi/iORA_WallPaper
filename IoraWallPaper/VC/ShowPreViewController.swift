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
   // 배경 화면 관련
   public var image: UIImage?
   @IBOutlet private weak var imageView: UIImageView!
   
   // 상단 버튼
   @IBOutlet private weak var closeButton: UIButton!
   @IBOutlet private weak var downloadButton: UIButton!
   @IBOutlet private weak var displayTimeLabel: UILabel!
   @IBOutlet private weak var displayDateLabel: UILabel!
   
   // 버튼 컬러 설정
   public var brightness: Int?
   public lazy var color: UIColor = {
      guard let brightness = brightness else { return .black }
      return brightness == 0 ? .white : .black
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setImageAndColor()
   }
   
   // 이미지 설정 및 버튼 컬러 설정
   func setImageAndColor() {
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
   
   // 화면에 표시된 UI 숨김
   func isHiddenDisplayView(isHidden: Bool) {
      closeButton.isHidden = isHidden
      downloadButton.isHidden = isHidden
      displayTimeLabel.isHidden = isHidden
      displayDateLabel.isHidden = isHidden
   }
   
   //MARK: 상단 버튼 액션
   // 파일 다운로드
   @IBAction private func downloadAction(_ sender: UIButton) {
      isHiddenDisplayView(isHidden: true)
      
      guard let layer = UIApplication.shared.keyWindow?.layer else { return }
      var screenImage: UIImage?
      let scale = UIScreen.main.scale
      UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
      guard let context = UIGraphicsGetCurrentContext() else { return }
      layer.render(in: context)
      screenImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      guard let image = screenImage else { return }
      
      PHPhotoLibrary.shared().savePhoto(image: image, albumName: "iORA")
      
      isHiddenDisplayView(isHidden: false)
      
      let alert = UIAlertController(title: "Save Success :)", message: nil, preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default) { (_) in
         self.dismiss(animated: true, completion: nil)
      }
      alert.addAction(action)
      
      present(alert, animated: true, completion: nil)
   }
   
   // Close Action
   @IBAction private func closeAction(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
}
