//
//  WallPaper.swift
//  IoraWallPaper
//
//  Created by 박소정 on 2020/06/10.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Foundation
import Firebase

struct WallPaper: Codable {
   let brightness: Int
   let imageName: String
   let imageURL: String
   let tag: String?
}


class WallPapers {
   static let shared = WallPapers()
   private let ref = Database.database().reference()
   var images: [UIImage?] = []
   var data: [WallPaper] = []
   
   private init() {}
   
   func dataDownload(completion: @escaping () -> ()) {
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
            completion()
         }
      }
   }
   
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
}
