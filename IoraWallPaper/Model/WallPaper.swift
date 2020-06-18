//
//  WallPaper.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/10.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import Photos

//{
//    brightness = 0;
//    imageName = View02;
//    imageType =     {
//        retina = nil;
//        super = "https://firebasestorage.googleapis.com/v0/b/iora-wallpaper.appspot.com/o/WallPaper%2Fview02.png?alt=media&token=21d12265-a523-4ad5-bdf0-f37f0f493fcc";
//    };
//    tag = "#view";
//}
//{
//    brightness = 0;
//    imageName = View01;
//    imageType =     {
//        retina = nil;
//        super = "https://firebasestorage.googleapis.com/v0/b/iora-wallpaper.appspot.com/o/WallPaper%2Fview01.png?alt=media&token=0539aa4a-fd2f-4765-82af-afcecfa2d828";
//    };
//    tag = "#view";
//}
//"{\n  \"brightness\" : 0,\n  \"imageName\" : \"view01\",\n  \"imageType\" : {\n    \"super\" : \"https:\\/\\/firebasestorage.googleapis.com\\/v0\\/b\\/iora-wallpaper.appspot.com\\/o\\/WallPaper%2Fview01.png?alt=media&token=0539aa4a-fd2f-4765-82af-afcecfa2d828\",\n    \"retina\" : \"nil\"\n  },\n  \"tag\" : \"#view\"\n}"


struct ImageType: Codable {
   let superRetinaDeviceImageURL: String?
   let retinaDeviceImageURL: String?
   
   enum CodingKeys: String, CodingKey {
      case superRetinaDeviceImageURL = "super"
      case retinaDeviceImageURL = "retina"
   }
}

// 받아오는 데이터
struct WallPaperList: Decodable {
   let brightness: Int // brightness
   let imageName: String // imageName
   let imageType: ImageType // imageType
   let tag: String?
}

enum DisplayType: Int {
   case retina = 0
   case superRetina = 1
}

// 데이터 다운로드 및 싱글톤 객체
class WallPapers {
   static let shared = WallPapers()
   private let ref = Database.database().reference()
   var displayType: DisplayType?
   var images: [UIImage?] = []
   var data: [WallPaperList] = []
   
   private init() {}
   // 데이터 다운로드
   func dataDownload(completion: (() -> ())? = nil) {
      self.ref.child("list").observe(.value) { (snapshot) in
         DispatchQueue.global().async {
            self.images.removeAll()
            self.data.removeAll()
            for value in snapshot.children.reversed().shuffled() {
               guard let snap = value as? DataSnapshot, let dic = snap.value as? NSDictionary else { return }
               do {
                  let data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                  let wallpaper = try JSONDecoder().decode(WallPaperList.self, from: data)
                  self.data.append(wallpaper)
               } catch {
                  print(error.localizedDescription)
               }
            }
            completion?()
         }
      }
   }
   
   // 이미지 다운로드
   func imageDownload(index: Int, completion: @escaping (UIImage?) -> ()) {
      guard let deviceType = displayType else { fatalError("Invalid Display Size") }
      var urlString: String?
      if deviceType == .superRetina {
         urlString = data[index].imageType.superRetinaDeviceImageURL
      } else {
         urlString = data[index].imageType.retinaDeviceImageURL
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
               DispatchQueue.main.async {
                  let image = UIImage(data: data)
                  self.images[index] = image
                  completion(image)
               }
            }
         }
         
         take.resume()
      }
   }
   
   // 버튼 컬러 설정
   func getColor(brightness: Int?) -> UIColor {
      guard let brightness = brightness else { return .black }
      return brightness == 0 ? .white : .black
   }
   
   // 알럿 설정
   func downloadAlert(handler: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
      let alert = UIAlertController(title: "Save Success :)", message: nil, preferredStyle: .alert)
      if let handler = handler {
         let action = UIAlertAction(title: "OK", style: .default, handler: handler)
         alert.addAction(action)
      }
      return alert
   }
   
   // 이미지 다운로드
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
}
