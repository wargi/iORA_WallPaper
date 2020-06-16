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

// 받아오는 데이터
struct WallPaper: Codable {
   let brightness: Int
   let imageName: String
   let imageURL: String
   let tag: String?
}

// 데이터 다운로드 및 싱글톤 객체
class WallPapers {
   static let shared = WallPapers()
   private let ref = Database.database().reference()
   var images: [UIImage?] = []
   var data: [WallPaper] = []
   
   private init() {}
   // 데이터 다운로드
   func dataDownload(completion: (() -> ())? = nil) {
      self.ref.child("list").observe(.value) { (snapshot) in
         DispatchQueue.global().async {
            self.images.removeAll()
            self.data.removeAll()
            for value in snapshot.children.reversed() {
               guard let snap = value as? DataSnapshot, let dic = snap.value as? NSDictionary else { return }
               do {
                  let data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                  let wallpaper = try JSONDecoder().decode(WallPaper.self, from: data)
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
      guard let url = URL(string: data[index].imageURL) else { fatalError("invalid url") }
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
}
