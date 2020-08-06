//
//  ImageProvider.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/08/06.
//  Copyright © 2020 sangwook park. All rights reserved.
//
import UIKit
import Foundation

// 이미지를 제공하는 클래스
class ImageProvider {
   
   // 오퍼레이션 객체 생성
   fileprivate let operationQueue = OperationQueue()
   
   let wallpaper: MyWallPaper
   
   // 이니셜라이저에 <컴플리션 핸들러 더하기(셀에 이미지 전달)>
   init(wallpaper: MyWallPaper, completion: @escaping (UIImage?) -> ()) {
      
      self.wallpaper = wallpaper
      
      // 🔸url
      let url = PrepareForSetUp.getImageURL(info: wallpaper)
      
      // 🔸오퍼레이션 생성하기
      let dataLoad = ImageLoadOpertaion(url: url) {
         completion($0)
      }
      
      // 🔸오퍼레이션큐에 오퍼레이션 넣기 (앱이기 때문에 기다리지 않기)
      operationQueue.addOperation(dataLoad)
      
   }
   
   // 취소메서드
   func cancel() {
      operationQueue.cancelAllOperations()
   }
}
