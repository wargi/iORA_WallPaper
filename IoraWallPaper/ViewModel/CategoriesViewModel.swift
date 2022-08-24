//
//  CategoriesViewModel.swift
//  IoraWallPaper
//
//  Created by wargi on 2022/08/20.
//  Copyright © 2022 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class CategoriesViewModel: ObservableObject {
    @Published var categories: [Tag]
    
    init() {
        self.categories = WallPapers.shared.tags
        
        let a = Tag(id: UUID(), info: TagInfo(name: "Winter", desc: "How do you overcome the servere cold weather?"), result: [])
        let b = Tag(id: UUID(), info: TagInfo(name: "Fall", desc: "Let\'s go leat peeping."), result: [])
        let c = Tag(id: UUID(), info: TagInfo(name: "Summer", desc: "Is there any way to beat the heat?"), result: [])
        let d = Tag(id: UUID(), info: TagInfo(name: "Spring", desc: "Spring is already in the air."), result: [])
        
        categories.append(contentsOf: [a, b, c, d])
    }
}
