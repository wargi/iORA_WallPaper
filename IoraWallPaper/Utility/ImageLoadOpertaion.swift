//
//  ImageLoadOpertaion.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/08/06.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Foundation

class ImageLoadOpertaion: AsyncOperation {
   fileprivate let url: URL
   fileprivate let completion: ((UIImage?) -> ())?
   fileprivate var loadImage: UIImage?
   
   init(url: URL, completion: ((UIImage?) -> ())?) {
      self.url = url
      self.completion = completion
      super.init()
   }
   
   override func main() {
      if self.isCancelled { return }
      
      if let image = WallPapers.shared.cacheImage[url] {
         if self.isCancelled { return }
         self.loadImage = image
         self.completion?(image)
         self.state = .Finished
         return
      }
      
      let request = URLRequest(url: self.url)
      let task = URLSession.shared.dataTask(with: request) { data, _, err in
         if let err = err {
            print(err.localizedDescription)
            return
         }
         
         if self.isCancelled { return }
         
         if let data = data, let image = UIImage(data: data) {
            self.loadImage = image
            self.completion?(image)
            self.state = .Finished
            WallPapers.shared.cacheImage.updateValue(image, forKey: self.url)
         } else {
            return
         }
      }
      
      task.resume()
   }
}
