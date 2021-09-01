//
//  DetailImageViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/25.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Action

final class DetailImageViewModel: CommonViewModel {
    var wallpapers: [MyWallPaper] // 페이지 데이터 목록
    let wallpapersSubject: BehaviorSubject<[MyWallPaper]>
    
    func showCalendarVC(index: Int) -> CalendarViewController? {
        guard var calendarVC = storyboard.instantiateViewController(withIdentifier: CalendarViewController.identifier) as? CalendarViewController else { return nil }
        
        let viewModel = CalendarViewModel(info: wallpapers[index])
        calendarVC.bind(viewModel: viewModel)
        
        return calendarVC
    }
    
    func showPreViewVC(index: Int) -> ShowPreViewController? {
        guard var showPreViewVC = storyboard.instantiateViewController(withIdentifier: ShowPreViewController.identifier) as? ShowPreViewController else { return nil }
        
        let viewModel = ShowPreViewModel(wallpaper: wallpapers[index])
        showPreViewVC.bind(viewModel: viewModel)
        
        return showPreViewVC
    }
    
    func downloadAction(index: Int) -> UIAlertController? {
        let wallpaper = wallpapers[index]
        guard let url = PrepareForSetUp.getImageURL(info: wallpaper) else { return nil }
        guard let image = WallPapers.shared.cacheImage[url] else { return nil }
        guard let alert = PrepareForSetUp.shared.imageFileDownload(image: image) else { return nil }
        
        return alert
    }
    
    init(wallpapers: [MyWallPaper]) {
        self.wallpapers = wallpapers
        self.wallpapersSubject = BehaviorSubject<[MyWallPaper]>(value: wallpapers)
    }
}
