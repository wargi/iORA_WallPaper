//
//  Tags.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/02.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation

struct Tags {
   var list: [Tag]
   var representImage: [MyWallPaper]
}

struct Tag {
   var info: TagInfo
   var result: [MyWallPaper]
}

struct TagInfo: Codable {
   let name: String
   let desc: String
   
   enum CodingKeys: String, CodingKey {
      case name = "tagName"
      case desc
   }
}
