//
//  CommonViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/02.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation

class CommonViewModel: NSObject {
   let sceneCoordinator: SceneCoordinatorType
   
   init(sceneCoordinator: SceneCoordinatorType) {
      self.sceneCoordinator = sceneCoordinator
   }
}
