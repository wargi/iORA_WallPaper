//
//  Font+.swift
//  IoraWallPaper
//
//  Created by wargi on 2022/08/20.
//  Copyright © 2022 sangwook park. All rights reserved.
//

import SwiftUI

extension Font {
    static func nanumGothic(size: CGFloat) -> Self {
        return .custom("nanumGothic", size: size)
    }
    
    static func nanumGothicBold(size: CGFloat) -> Self {
        return .custom("nanumGothicBold", size: size)
    }
    
    static func nanumGothicExtraBold(size: CGFloat) -> Self {
        return .custom("nanumGothicExtraBold", size: size)
    }
}
