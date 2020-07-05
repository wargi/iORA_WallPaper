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
   let showCalendarAction: Action<Int, Void>
   let showPreViewAction: Action<Int, Void>
   let downloadAction: Action<Int, Void>
   let popAction: CocoaAction
   
   // Share Action
   func shareAction(currentIndex: Int) -> UIActivityViewController {
      guard let image = wallpapers[currentIndex].image else { fatalError("invalid Image") }
      let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
      
      return activity
   }
   
   init(wallpapers: [MyWallPaper], sceneCoordinator: SceneCoordinatorType, showCalendarAction: Action<Int, Void>? = nil, showPreViewAction: Action<Int, Void>? = nil, downloadAction: Action<Int, Void>? = nil, popAction: CocoaAction? = nil) {
      self.wallpapers = wallpapers
      self.wallpapersSubject = BehaviorSubject<[MyWallPaper]>(value: wallpapers)
      
      self.showCalendarAction = Action<Int, Void> { index in
         if let action = showCalendarAction {
            action.execute(index)
         }
         let wallpaper = wallpapers[index]
         let viewModel = CalendarViewModel(info: wallpaper, sceneCoordinator: sceneCoordinator)
         let scene = Scene.calendar(viewModel)
         
         return sceneCoordinator.transition(to: scene, using: .modal, animated: true).asObservable().map { _ in }
      }
      
      self.showPreViewAction = Action<Int, Void> { index in
         if let action = showPreViewAction {
            action.execute(index)
         }
         let wallpaper = wallpapers[index]
         let viewModel = ShowPreViewModel(wallpaper: wallpaper,
                                          sceneCoordinator: sceneCoordinator)
         let scene = Scene.showPre(viewModel)
         
         return sceneCoordinator.transition(to: scene, using: .modal, animated: true).asObservable().map { _ in }
      }
      
      self.downloadAction = Action<Int, Void> { index in
         if let action = downloadAction {
            action.execute(index)
         }
         
         let wallpaper = wallpapers[index]
         PrepareForSetUp.shared.imageFileDownload(image: wallpaper.image)
         
         return sceneCoordinator.close(animated: true).asObservable().map { _ in }
      }
      
      self.popAction = CocoaAction {
         if let action = popAction {
            action.execute(())
         }
         return sceneCoordinator.close(animated: true).asObservable().map { _ in }
      }
      
      super.init(sceneCoordinator: sceneCoordinator)
   }
}
