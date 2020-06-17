//
//  DetailViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/10.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController {
   // 배경 화면 관련
   public var image: UIImage?
   @IBOutlet private weak var wallPaperImageView: UIImageView!
   
   // 상단 버튼
   @IBOutlet private weak var backButton: UIButton!
   @IBOutlet private weak var calendarButton: UIButton!
   @IBOutlet private weak var previewButton: UIButton!
   @IBOutlet private weak var saveButton: UIButton!
   @IBOutlet private weak var shareButton: UIButton!
   
   // 버튼 컬러 설정 관련
   public var brightness: Int?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setImageAndColor()
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
   
   // 이미지 설정 및 버튼 컬러 설정
   func setImageAndColor() {
      guard let image = image else { fatalError("wall paper is invalid") }
      let color = WallPapers.shared.getColor(brightness: brightness)
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
   
   // 화면에 표시된 UI 숨김
   func isHiddenDisplayUI(isHidden: Bool) {
      backButton.isHidden = isHidden
      calendarButton.isHidden = isHidden
      previewButton.isHidden = isHidden
      saveButton.isHidden = isHidden
      shareButton.isHidden = isHidden
   }

   
   //MARK: 상단 버튼 액션
   // 파일 다운로드
   @IBAction private func downlaodAction(_ sender: UIButton) {
      isHiddenDisplayUI(isHidden: true)
      WallPapers.shared.screenImageDownload()
      isHiddenDisplayUI(isHidden: false)
      present(WallPapers.shared.downloadAlert(), animated: true) {
         self.dismiss(animated: true, completion: nil)
      }
   }
   
   // Share Action
   @IBAction private func shareAction(_ sender: UIButton) {
      guard let image = image else { return }
      
      let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
      print(activityVC)
      
      present(activityVC, animated: true, completion: nil)
   }
   
   // Close Action
   @IBAction func popAction() {
      navigationController?.popViewController(animated: true)
   }
}
