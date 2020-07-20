//
//  SetUp.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/02.
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
   private let ref = Database.database().reference()
   var displayType: DisplayType {
      let height = UIScreen.main.bounds.height
      if height == 896 || height == 812 {
         return .superRetina
      } else {
         return .retina
      }
   }
   
   private init() {}
   
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
      DispatchQueue.global().async {
         let urlString = PrepareForSetUp.shared.displayType == .retina ? info.wallpaper.imageType.retinaDeviceImageURL : info.wallpaper.imageType.superRetinaDeviceImageURL
         
         guard let urlStr = urlString, let url = URL(string: urlStr) else {
            fatalError("Invalid URL")
         }
         
         let config = URLSessionConfiguration.default
         config.requestCachePolicy = .returnCacheDataElseLoad
         let session = URLSession(configuration: config)
         
         
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
   func screenImageDownload() -> UIAlertController? {
      guard let layer = UIApplication.shared.keyWindow?.layer else { return nil }
      var screenImage: UIImage?
      let scale = UIScreen.main.scale
      UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
      guard let context = UIGraphicsGetCurrentContext() else { return nil }
      layer.render(in: context)
      screenImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      guard let image = screenImage else { return nil }
      
      return PHPhotoLibrary.shared().savePhoto(image: image, albumName: "IORA")
   }
   
   // Photo Library +++ ADD FILE
   func imageFileDownload(image: UIImage?) -> UIAlertController? {
      guard let image = image else { return nil }
      
      return PHPhotoLibrary.shared().savePhoto(image: image, albumName: "IORA")
   }
//      let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
//      if let handler = handler {
//         let action = UIAlertAction(title: "OK", style: .default, handler: handler)
//         alert.addAction(action)
//      }
//      return alert
}
