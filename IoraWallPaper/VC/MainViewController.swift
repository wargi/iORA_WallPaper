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
   @IBOutlet private weak var filterButton: UIButton!
   @IBOutlet private weak var searchButton: UIButton!
   @IBOutlet weak var topConstraint: NSLayoutConstraint!
   
   var loadingQueue = OperationQueue()
   var loadingOperations: [IndexPath: DataLoadOperation] = [:]
   
   var viewModel: MainViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      WallPapers.shared.subscribeFavorite()
      collectionViewSetUp()
      configure()
   }
   
   func bindViewModel() {
      do {
         try viewModel.reachability?.startNotifier()
      } catch {
         print(error.localizedDescription)
      }
      
      // 네트워크 사용 가능 상태 일 때
      viewModel.reachability?.whenReachable = { reachability in
         self.collectionView.isHidden = false
         self.dataLoad()
      }
      
      // 네트워크 사용 불가능 상태 일 때
      viewModel.reachability?.whenUnreachable = { _ in
         self.collectionView.isHidden = true
      }
      
      viewModel.presentWallpapers
         .subscribe(onNext: {
            self.viewModel.wallpapers = $0
            self.dataLoad()
         })
         .disposed(by: rx.disposeBag)
      
      // 메인리스트 정렬 액션
      filterButton.rx.tap
         .subscribe(onNext: {
            self.viewModel.reverse = !self.viewModel.reverse
            self.viewModel.presentWallpapers.onNext(self.viewModel.wallpapers.reversed())
         })
         .disposed(by: rx.disposeBag)
      
      collectionView.rx.itemSelected
         .map { $0.item }
         .map { index -> [MyWallPaper] in
            self.collectionView.deselectItem(at: IndexPath(item: index, section: 0), animated: true)
            var result: [MyWallPaper]
            
            let wallpapers = self.viewModel.wallpapers
            let temp = index + 9 < wallpapers.count ? wallpapers[index ... index+9] : wallpapers[index...]
            result = Array(temp)
            
            return result
      }
      .map { self.viewModel.showDetailVC(wallpapers: $0) }
      .subscribe(onNext: {
         self.navigationController?.pushViewController($0, animated: true)
      })
      .disposed(by: rx.disposeBag)
      
      searchButton.rx.tap
         .map { self.viewModel.showSearchVC() }
         .subscribe(onNext: {
            self.navigationController?.pushViewController($0, animated: true)
         })
         .disposed(by: rx.disposeBag)
   }
   
   // 기본 설정
   func configure() {
      let tap = UITapGestureRecognizer(target: self, action: #selector(self.dataLoad))
      notConnectView.addGestureRecognizer(tap)
      
      let refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: #selector(dataLoad), for: .valueChanged)
      collectionView.refreshControl = refreshControl
   }
   
   // 데이타 로드
   @objc func dataLoad() {
      DispatchQueue.main.async {
         self.collectionView.refreshControl?.endRefreshing()
         self.collectionView.reloadData()
      }
   }
   
   func collectionViewSetUp() {
      if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
         let screenWidth = UIScreen.main.bounds.size.width
         var width = screenWidth - 20
         var height = width * 0.75
         
         layout.minimumInteritemSpacing = 10
         layout.minimumLineSpacing = 10
         layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
         layout.headerReferenceSize = CGSize(width: width, height: height)
         
         width = (screenWidth - 30) / 2
         height = PrepareForSetUp.shared.displayType == .retina ? width * 1.77 : width * 2.16
         
         layout.itemSize = CGSize(width: width, height: height)
      }
   }
   
   // 네트워크 추적 해제
   deinit {
      viewModel.reachability?.stopNotifier()
      viewModel.reachability = nil
   }
}

extension MainViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return viewModel.wallpapers.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallPaperCollectionViewCell.identifier, for: indexPath) as? WallPaperCollectionViewCell else { fatalError("invalid mainCell") }
      
      let wallpaper = viewModel.wallpapers[indexPath.item]
      
      if let image = wallpaper.image {
         cell.wallpaperImageView.image = image
      } else {
         cell.configure(info: wallpaper)
      }
      
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: HeaderCollectionReusableView.identifier,
                                                                         for: indexPath) as? HeaderCollectionReusableView else { fatalError("invalid header") }
      
      header.configure()
      
      return header
   }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      if let dataLoader = loadingOperations[indexPath] {
         dataLoader.cancel()
         loadingOperations.removeValue(forKey: indexPath)
      }
   }
   
   func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      guard let cell = cell as? WallPaperCollectionViewCell else { return }
      
      let updatedCellClosure: (MyWallPaper?) -> () = { [weak self] wallpaper in
         guard let self = self else { return }
         
         if let image = wallpaper?.image {
            DispatchQueue.main.async {
               cell.wallpaperImageView.image = image
            }
         }
         self.loadingOperations.removeValue(forKey: indexPath)
      }
      
      if let dataLoader = loadingOperations[indexPath] {
         if let myWallpaper = dataLoader.wallpaper {
            if let image = myWallpaper.image {
               DispatchQueue.main.async {
                  cell.wallpaperImageView.image = image
               }
            }
            self.loadingOperations.removeValue(forKey: indexPath)
         } else {
            dataLoader.loadingCompleteHandler = updatedCellClosure
         }
         
      } else {
         if let dataLoader = DataSotre().loadMyWallpaper(at: indexPath.item) {
            dataLoader.loadingCompleteHandler = updatedCellClosure
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
         }
      }
   }
}

extension MainViewController: UICollectionViewDataSourcePrefetching {
   func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
      for indexPath in indexPaths {
         if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
         }
         let dataStore = DataSotre()
         if let dataLoader = dataStore.loadMyWallpaper(at: indexPath.item) {
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
         }
      }
   }
}
