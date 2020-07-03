//
//  ViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/08.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MainViewController: UIViewController, ViewModelBindableType {
   @IBOutlet private weak var collectionView: UICollectionView!
   
   // 상단 UI
   @IBOutlet private weak var navigationView: UIView!
   @IBOutlet private weak var notConnectView: UIView!
   @IBOutlet private weak var presentingButton: UIButton!
   @IBOutlet private weak var filterButton: UIButton!
   @IBOutlet private weak var searchButton: UIButton!
   private var reachability: Reachability?
   
   var viewModel: MainViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      collectionViewSetUp()
      configure()
   }
   
   func bindViewModel() {
      viewModel.presentWallpapers
         .bind(to: collectionView.rx.items(cellIdentifier: WallPapeerCollectionViewCell.identifier,
                                           cellType: WallPapeerCollectionViewCell.self)) { item, wallpaper, cell in
         if let image = wallpaper.image {
            cell.wallpaperImageView.image = image
         } else {
            cell.configure(info: wallpaper)
         }
         
         cell.tagConfigure(info: nil, isHidden: true)
         let tags = WallPapers.shared.tags.list
         if !self.viewModel.isPresent, item < tags.count {
            cell.tagConfigure(info: tags[item].info, isHidden: false)
         }
      }
      .disposed(by: rx.disposeBag)
      
      presentingButton.rx.tap
         .subscribe {
            self.viewModel.presentAction()
         }
         .disposed(by: rx.disposeBag)
      
      filterButton.rx.tap
         .map { try self.viewModel.isPresenting.value() }
         .subscribe(onNext: {
            if $0 {
               self.viewModel.reverse = !self.viewModel.reverse
               self.viewModel.wallpapers.reverse()
               self.viewModel.presentWallpapers.onNext(self.viewModel.wallpapers)
            }
         })
         .disposed(by: rx.disposeBag)
      
      searchButton.rx.action = viewModel.searchAction
      
      collectionView.rx.itemSelected
         .map { $0.item }
         .map { index -> [MyWallPaper] in
            self.collectionView.deselectItem(at: IndexPath(item: index, section: 0), animated: true)
            var result: [MyWallPaper]
            if self.viewModel.isPresent {
               let wallpapers = self.viewModel.wallpapers
               let temp = index + 9 < wallpapers.count ? wallpapers[index ... index+9] : wallpapers[index...]
               result = Array(temp)
            } else {
               result = WallPapers.shared.tags.list[index].result
            }
            return result
         }
         .bind(to: viewModel.selectedAction.inputs)
         .disposed(by: rx.disposeBag)
   }
   
   // 기본 설정
   func configure() {
      reachability = Reachability()
      
      do {
         try reachability?.startNotifier()
      } catch {
         print(error.localizedDescription)
      }
      
      // 네트워크 사용 가능 상태 일 때
      reachability?.whenReachable = { reachability in
         self.collectionView.isHidden = false
         self.dataLoad()
      }
      
      // 네트워크 사용 불가능 상태 일 때
      reachability?.whenUnreachable = { _ in
         self.collectionView.isHidden = true
      }
      
      presentingButton.layer.cornerRadius = 30
      presentingButton.clipsToBounds = false
      presentingButton.layer.shadowColor = UIColor.black.cgColor
      presentingButton.layer.shadowOpacity = 0.5
      presentingButton.layer.shadowOffset = CGSize(width: 1, height: 1)
      presentingButton.layer.shadowRadius = 2
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(self.dataLoad))
      notConnectView.addGestureRecognizer(tap)
      
      let refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: #selector(dataLoad), for: .valueChanged)
      collectionView.refreshControl = refreshControl
   }
   
   // 데이타 로드
   @objc func dataLoad() {
      collectionView.refreshControl?.endRefreshing()
      collectionView.reloadData()
   }
   
   func collectionViewSetUp() {
      if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
         viewModel.isPresenting.subscribe(onNext: {
            if $0 {
               layout.headerReferenceSize = CGSize(width: self.collectionView.bounds.width, height: 300)
               let width = (self.collectionView.bounds.width - 30) / 2
               layout.itemSize = CGSize(width: width, height: width * 2)
               layout.minimumInteritemSpacing = 10
               layout.minimumLineSpacing = 10
            } else {
               layout.headerReferenceSize = CGSize(width: self.collectionView.bounds.width, height: 0)
               let width = (self.collectionView.bounds.width - 30) * 0.9
               layout.itemSize = CGSize(width: width, height: width * 1.7)
               layout.minimumInteritemSpacing = 25
               layout.minimumLineSpacing = 20
            }
         })
            .disposed(by: rx.disposeBag)
      }
      
      collectionView.register(HeaderCollectionReusableView.self,
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: HeaderCollectionReusableView.identifier)
      if let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader,
                                                       at: IndexPath(item: 0, section: 0)) as? HeaderCollectionReusableView {
         header.configure()
      }
   }
   
   // 네트워크 추적 해제
   deinit {
      reachability?.stopNotifier()
      reachability = nil
   }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
}
