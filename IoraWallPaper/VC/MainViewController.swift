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
import RxDataSources

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
      //컬렉션뷰 데이터 소스
      Observable.combineLatest(viewModel.headerSubject, viewModel.presentWallpapers)
         .map { $0.1 }
         .bind(to: collectionView.rx.items) { collection, index, wallpaper in
            if index == 0 && self.viewModel.isPresent {
               guard let cell = collection.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.identifier, for: IndexPath(item: 0, section: 0)) as? HeaderCollectionViewCell else { fatalError() }
               
               cell.configure()
               
               return cell
            }
            
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: WallPapeerCollectionViewCell.identifier,
                                                     for: IndexPath(item: index, section: 0)) as? WallPapeerCollectionViewCell else { fatalError() }

            cell.tagConfigure(info: nil, isHidden: true)
            if !self.viewModel.isPresent {
               cell.tagConfigure(info: WallPapers.shared.tags.list[index].info,
                                 isHidden: false)
            }
            
            if let image = wallpaper.image {
               cell.wallpaperImageView.image = image
            } else {
               cell.configure(info: wallpaper)
            }
            
            return cell
         }
         .disposed(by: rx.disposeBag)
      
      // 컬렉션 전환 액션
      presentingButton.rx.tap
         .subscribe {
            if let _ = $0.element {
               self.viewModel.presentAction()
            }
      }
      .disposed(by: rx.disposeBag)
      
      // 메인리스트 정렬 액션
      filterButton.rx.tap
         .map { try self.viewModel.isPresenting.value() }
         .subscribe(onNext: {
            if $0 {
               self.viewModel.reverse = !self.viewModel.reverse
               self.viewModel.wallpapers.reverse()
//               self.viewModel.presentWallpapers.onNext(self.viewModel.wallpapers)
            }
         })
         .disposed(by: rx.disposeBag)
      
      // MainViewVC => SearchVC
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
               layout.minimumInteritemSpacing = 10
               layout.minimumLineSpacing = 10
            } else {
               layout.minimumInteritemSpacing = 25
               layout.minimumLineSpacing = 20
            }
         })
            .disposed(by: rx.disposeBag)
      }
   }
   
   // 네트워크 추적 해제
   deinit {
      reachability?.stopNotifier()
      reachability = nil
   }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      var size: CGSize = CGSize(width: 0, height: 0)
      viewModel.isPresenting
         .subscribe(onNext: {
            let collectionWidth = self.collectionView.bounds.width - 30
            var width: CGFloat = 0
            var height: CGFloat = 0
            
            if $0 {
               if indexPath.item == 0 {
                  width = collectionWidth + 10
                  height = 300
               } else {
                  width = collectionWidth / 2
                  height = width * 2
               }
               
               size = CGSize(width: width, height: height)
            } else {
               if let displayType = PrepareForSetUp.shared.displayType {
                  width = displayType == .retina ? collectionWidth * 0.8 : collectionWidth * 0.88
                  height = displayType == .retina ? width * 2 : width * 2.2
               }
               size = CGSize(width: width, height: height)
            }
         })
         .disposed(by: rx.disposeBag)
      return size
   }
}
