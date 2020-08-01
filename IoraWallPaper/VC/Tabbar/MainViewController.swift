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
   
   // 오퍼레이션큐생성
   // 🎾 취소관리를 위한 indexPath및 오퍼레이션을 저장
   private let queue = OperationQueue()
   private var operations: [IndexPath: [Operation]] = [:]
   
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
      
      // 오퍼레이션 생성
      let downloadOp = NetworkImageOperation(url: PrepareForSetUp.getImageURL(info: wallpaper))
      let tiltShiftOp = TiltShiftOperation()
      
      // 오퍼레이션 의존성 설정
      tiltShiftOp.addDependency(downloadOp)
      
      // 🎾 오퍼레이션에 콜백함수의 전달(TiltShilt가 끝나고 할일) (메인쓰레드에서 실행됨)
      tiltShiftOp.onImageProcessed = { image in
         // indexPath에 해당하는 셀찾아서
         guard let cell = collectionView.cellForItem(at: indexPath) as? WallPaperCollectionViewCell else { return }
         
         // 액티비티 인디케이터 멈추고, 이미지표시
         cell.isLoading = false
         cell.display(image: image)
      }
      
      // 오퍼레이션큐에 오퍼레이션 넣기
      queue.addOperation(downloadOp)
      queue.addOperation(tiltShiftOp)
      
      // indexPath에 기존 operation이 있으면 일단 취소시키기
      if let existingOperations = operations[indexPath] {
         for operation in existingOperations {
            operation.cancel()
         }
      }
      
      // 🎾 향후, 오퍼레이션 취소를 위해 딕셔너리에 찾기쉽게 [indexPath:[오퍼레이션]]으로 저장
      operations[indexPath] = [tiltShiftOp, downloadOp]
      
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
   // 🎾 컬렉션뷰의 셀이 지났갔을때, 취소를 위한 구현부분
   func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      
      // 🎾 indexPath에 해당하는 Operation찾아서 취소
      if let operations = operations[indexPath] {
         for operation in operations {
            operation.cancel()
         }
      }
   }
}
