//
//  DataLoadOperation.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/09.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation

struct DataSotre {
   func loadMyWallpaper(at index: Int) -> DataLoadOperation? {
      if WallPapers.shared.myWallPapers[index].image == nil {
         let wallpaper = WallPapers.shared.myWallPapers[index]
         return DataLoadOperation(wallpaper)
      }
      return .none
   }
}

class DataLoadOperation: Operation {
   var wallpaper: MyWallPaper?
   var loadingCompleteHandler: ((MyWallPaper?) -> Void)?
   
   private let myWallpaper: MyWallPaper
   
   init(_ myWallpaper: MyWallPaper) {
      self.myWallpaper = myWallpaper
   }
   
   override func main() {
      if isCancelled { return }
      
      wallpaper = myWallpaper
      
      if let loadingCompleteHandler = loadingCompleteHandler {
         DispatchQueue.main.async {
            loadingCompleteHandler(self.myWallpaper)
         }
      }
   }
}
