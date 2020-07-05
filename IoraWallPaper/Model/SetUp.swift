//
//  SetUp.swift
//  IoraWallPaper
//
//  Created by 박소정 on 2020/07/02.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import Photos

// 디스플레이 타입 설정
enum DisplayType: Int {
   case retina = 0
   case superRetina = 1
}

// 디스플레이 별 이미지 타입 설정
struct ImageType: Codable {
   let superRetinaDeviceImageURL: String?
   let retinaDeviceImageURL: String?
   
   enum CodingKeys: String, CodingKey {
      case superRetinaDeviceImageURL = "super"
      case retinaDeviceImageURL = "retina"
   }
}

class PrepareForSetUp {
   static let shared = PrepareForSetUp()
   
   private init() {}
   private let ref = Database.database().reference()
   var displayType: DisplayType?
   
   //MARK: COLOR SETTING
   // 디바이스 사이즈 계산
   func getDeviceScreenSize() {
      // (414.0, 896.0) // 11 pro max
      // (375.0, 812.0) // 11 pro
      // (414.0, 896.0) // 11
      // (414.0, 736.0) // 8 plus
      // (375.0, 667.0) // se
      // (375.0, 667.0) // 8
      
      switch UIScreen.main.bounds.size.height {
      case 896, 812:
         self.displayType = .superRetina
      case 736, 667:
         self.displayType = .retina
      default:
         break
      }
   }
   
   // 버튼 컬러 설정
   func getColor(brightness: Int?) -> UIColor {
      guard let brightness = brightness else { return .black }
      return brightness == 0 ? .white : .black
   }
   
   //MARK: FIREBASE DATA DOWNLOAD
   func firebaseDataDownload(completion: (([MyWallPaper]) -> ())? = nil) {
      var myWallPapers: [MyWallPaper] = []
      
      self.ref.child("list").observe(.value) { (snapshot) in
         DispatchQueue.global().async {
            for value in snapshot.children.reversed() {
               guard let snap = value as? DataSnapshot, let dic = snap.value as? NSDictionary else { return }
               do {
                  let data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                  let wallpaper = try JSONDecoder().decode(ImageInfo.self, from: data)
                  myWallPapers.append(MyWallPaper(info: wallpaper))
               } catch {
                  print(error.localizedDescription)
               }
            }
            completion?(myWallPapers)
         }
      }
   }
   
   func firebaseTagDataDownload(completion: (([Tag]) -> ())? = nil) {
      var tags = [Tag]()

      self.ref.child("tagList").observe(.value) { (snapshot) in
         DispatchQueue.global().async {
            for value in snapshot.children.reversed() {
               guard let snap = value as? DataSnapshot, let dic = snap.value as? NSDictionary else { return }
               do {
                  let data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                  let tagInfo = try JSONDecoder().decode(TagInfo.self, from: data)
                  tags.append(Tag(info: tagInfo, result: []))
               } catch {
                  print(error.localizedDescription)
               }
            }
            completion?(tags)
         }
      }
   }
   
   //MARK: IMAGE DOWNLOAD
   // 이미지 다운로드
   func imageDownload(info: MyWallPaper, completion: @escaping (UIImage?) -> ()) {
      guard let deviceType = displayType else { fatalError("Invalid Display Size") }
      var urlString: String?
      if deviceType == .superRetina {
         urlString = info.wallpaper.imageType.superRetinaDeviceImageURL
      } else {
         urlString = info.wallpaper.imageType.retinaDeviceImageURL
      }
      guard let urlStr = urlString, let url = URL(string: urlStr) else {
         fatalError("Invalid URL")
      }
      
      let session = URLSession.shared
      
      DispatchQueue.global().async {
         let take = session.dataTask(with: url) { (data, resp, err) in
            if let err = err {
               print(err.localizedDescription)
            } else if let data = data {
               let image = UIImage(data: data)
               info.image = image
               DispatchQueue.main.async {
                  completion(image)
               }
            }
         }
         take.resume()
      }
   }
   
   // 달력 이미지 파일 다운로드
   func screenImageDownload() {
      guard let layer = UIApplication.shared.keyWindow?.layer else { return }
      var screenImage: UIImage?
      let scale = UIScreen.main.scale
      UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
      guard let context = UIGraphicsGetCurrentContext() else { return }
      layer.render(in: context)
      screenImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      guard let image = screenImage else { return }
      
      PHPhotoLibrary.shared().savePhoto(image: image, albumName: "IORA")
   }
   
   // Photo Library +++ ADD FILE
   func imageFileDownload(image: UIImage?) {
      guard let image = image else { return }
      
      PHPhotoLibrary.shared().savePhoto(image: image, albumName: "IORA")
   }
   
   // 알럿 설정
   @discardableResult
   func completedAlert(handler: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
      let alert = UIAlertController(title: "Save Success :)", message: nil, preferredStyle: .alert)
      if let handler = handler {
         let action = UIAlertAction(title: "OK", style: .default, handler: handler)
         alert.addAction(action)
      }
      return alert
   }
}
