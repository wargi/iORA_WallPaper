//
//  SceneCoordinatorType.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/26.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
   @discardableResult
   func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
   
   @discardableResult
   func close(animated: Bool) -> Completable
}
