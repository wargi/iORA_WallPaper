//
//  DetailImageViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/25.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx
import Action

class DetailImageViewModel: CommonViewModel {
   var wallpapers: [MyWallPaper] // 페이지 데이터 목록
   let wallpapersSubject: BehaviorSubject<[MyWallPaper]>
   
   func showCalendarVC(index: Int) -> CalendarViewController {
      guard var calendarVC = storyboard.instantiateViewController(withIdentifier: CalendarViewController.identifier) as? CalendarViewController else { fatalError("Not Created CalendarVC") }
      
      let viewModel = CalendarViewModel(info: wallpapers[index])
      calendarVC.bind(viewModel: viewModel)
      
      return calendarVC
   }
   
   func showPreViewVC(index: Int) -> ShowPreViewController {
      guard var showPreViewVC = storyboard.instantiateViewController(withIdentifier: ShowPreViewController.identifier) as? ShowPreViewController else { fatalError("Not Created CalendarVC") }
      
      let viewModel = ShowPreViewModel(wallpaper: wallpapers[index])
      showPreViewVC.bind(viewModel: viewModel)
      
      return showPreViewVC
   }
   
   let downloadAction: Action<Int, Void>
   
   // Share Action
   func shareAction(currentIndex: Int) -> UIActivityViewController {
      guard let image = wallpapers[currentIndex].image else { fatalError("invalid Image") }
      let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
      
      return activity
   }
   
   init(wallpapers: [MyWallPaper], downloadAction: Action<Int, Void>? = nil) {
      self.wallpapers = wallpapers
      self.wallpapersSubject = BehaviorSubject<[MyWallPaper]>(value: wallpapers)
      
      self.downloadAction = Action<Int, Void> { index in
         if let action = downloadAction {
            action.execute(index)
         }
         
         let wallpaper = wallpapers[index]
         PrepareForSetUp.shared.imageFileDownload(image: wallpaper.image)
         
         return Observable.empty()
      }
   }
}
