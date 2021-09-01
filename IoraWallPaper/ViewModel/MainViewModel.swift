//
//  MainViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/25.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

final class MainViewModel: CommonViewModel {
    let disposedBag = DisposeBag()
    
    var reachability: Reachability? = Reachability()
    var wallpapers: [MyWallPaper]
    var presentWallpapers: BehaviorSubject<[MyWallPaper]>
    var reverse = false
    
    func setMyWallpaper() {
        WallPapers.shared.wallpaperSubject
            .subscribe(onNext: {
                self.presentWallpapers.onNext($0)
            })
            .disposed(by: disposedBag)
    }
    
    func showSearchVC() -> SearchViewController? {
        guard var searchVC = storyboard.instantiateViewController(withIdentifier: SearchViewController.identifier) as? SearchViewController else { return nil }
        
        searchVC.bind(viewModel: SearchViewModel(tags: WallPapers.shared.tags))
        
        return searchVC
    }
    
    func showDetailVC(wallpapers: [MyWallPaper]) -> DetailImageViewController? {
        guard var detailImageVC = storyboard.instantiateViewController(withIdentifier: DetailImageViewController.identifier) as? DetailImageViewController else { return nil }
        
        let viewModel = DetailImageViewModel(wallpapers: wallpapers)
        detailImageVC.bind(viewModel: viewModel)
        
        return detailImageVC
    }
    
    override init() {
        self.wallpapers = []
        self.presentWallpapers = BehaviorSubject<[MyWallPaper]>(value: wallpapers)
        
        super.init()
        
        setMyWallpaper()
    }
}
