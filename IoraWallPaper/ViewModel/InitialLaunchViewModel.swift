//
//  InitialLaunchViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/09.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class InitialLaunchViewModel: CommonViewModel {
    var imagesSubject: BehaviorSubject<[UIImage?]>
    
    func showMainVC() -> CustomTabbarController? {
        guard let tabbarVC = storyboard.instantiateViewController(withIdentifier: CustomTabbarController.identifier) as? CustomTabbarController,
              let mainNav = tabbarVC.viewControllers?.first as? UINavigationController,
              var mainVC = mainNav.viewControllers.first as? MainViewController else { return nil }
        
        mainVC.bind(viewModel: MainViewModel())
        UserDefaults.standard.set(true, forKey: "isLaunch")
        
        return tabbarVC
    }
    
    override init() {
        var images: [UIImage?]
        if PrepareForSetUp.shared.displayType == .retina {
            images = [
                UIImage(named: "rlanding_wallpapers"),
                UIImage(named: "rlanding_favorite"),
                UIImage(named: "rlanding_category"),
                UIImage(named: "rlanding_detail"),
                UIImage(named: "rlanding_calendar"),
                UIImage(named: "rlanding_watch")
            ]
        } else {
            images = [
                UIImage(named: "slanding_wallpapers"),
                UIImage(named: "slanding_favorite"),
                UIImage(named: "slanding_category"),
                UIImage(named: "slanding_detail"),
                UIImage(named: "slanding_calendar"),
                UIImage(named: "slanding_watch")
            ]
        }
        
        self.imagesSubject = BehaviorSubject<[UIImage?]>(value: images)
        super.init()
    }
}
