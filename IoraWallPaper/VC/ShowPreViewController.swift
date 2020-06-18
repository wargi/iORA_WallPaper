//
//  ShowPreViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/11.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

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
   
   //MARK: 상단 버튼 액션
   // 파일 다운로드
   @IBAction private func downloadAction(_ sender: UIButton) {
      WallPapers.shared.imageFileDownload(image: image)
      
      present(WallPapers.shared.downloadAlert(handler: { (_) in
         self.dismiss(animated: true, completion: nil)
      }), animated: true, completion: nil)
   }
   
   // Close Action
   @IBAction private func closeAction(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
}
