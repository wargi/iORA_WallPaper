//
//  TransitionStyle.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/26.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation

enum TransitionStyle {
   case root
   case push
   case modal
   case tap
}

enum TransitionError: Error {
   case navigationControllerMissing
   case cannotPop
   case unknown
}
