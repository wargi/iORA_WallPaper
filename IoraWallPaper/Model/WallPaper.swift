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
      print("입장")
      print(self.ref.child("list").observe(.value, with: <#T##(DataSnapshot) -> Void#>))
      self.ref.child("list").observe(.value) { (snap) in
         print(snap)
      }
      
      self.ref.child("list").observe(.value) { (snapshot) in
         print("=================0==================")
         DispatchQueue.global().async {
            self.images.removeAll()
            self.data.removeAll()
            for value in snapshot.children {
               print("=================1==================")
               print(value)
               guard let snap = value as? DataSnapshot, let dic = snap.value as? NSDictionary else { return }
               do {
                  print("====================2====================")
                  let data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                  let wallpaper = try JSONDecoder().decode(WallPaper.self, from: data)
                  self.data.append(wallpaper)
                  completion()
               } catch {
                  print(error.localizedDescription)
               }
            }
         }
      }
   }
}
