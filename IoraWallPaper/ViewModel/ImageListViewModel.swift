//
//  ImageListViewModel.swift
//  IoraWallPaper
//
//  Created by wargi on 2022/08/20.
//  Copyright © 2022 sangwook park. All rights reserved.
//

import Foundation

final class ImageListViewModel: ObservableObject {
    @Published var wallpapers: [MyWallPaper]
    
    init(wallpapers: [MyWallPaper]) {
        self.wallpapers = wallpapers
    }
}
