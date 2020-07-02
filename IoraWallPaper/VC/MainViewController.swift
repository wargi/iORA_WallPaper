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
   private var reachability: Reachability?
   
   var isPresenting = BehaviorSubject<Bool>(value: true)
   
   var viewModel: MainViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      collectionViewSetUp()
      configure()
   }
   
   func bindViewModel() {
      viewModel.wallpapers
         .bind(to: collectionView.rx.items(cellIdentifier: WallPapeerCollectionViewCell.identifier,
                                              cellType: WallPapeerCollectionViewCell.self)) { item, wallpaper, cell in
         if let image = wallpaper.image {
            cell.wallpaperImageView.image = image
         } else {
            cell.configure(info: wallpaper)
         }
                                                
         cell.tagConfigure(info: nil, isHidden: true)
         self.isPresenting.subscribe(onNext: {
            if !$0, let tags = try? WallPapers.shared.tags.value(), item < tags.list.count {
               cell.tagConfigure(info: tags.list[item].info, isHidden: false)
            }
         })
            .disposed(by: self.rx.disposeBag)
         
      }
      .disposed(by: rx.disposeBag)
      
      filterButton.rx.action = viewModel.filteringAction()
      presentingButton.rx.tap
         .bind(onNext: { _ in
            if let flag = try? self.isPresenting.value() {
               self.isPresenting.onNext(!flag)
            }
            })
            .disposed(by: rx.disposeBag)
      
      presentingButton.rx.action = viewModel.presentingAction()
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
            isPresenting.subscribe(onNext: {
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
            print("Launch")
         }
      }
      
      //MARK: Button Action
      //
      //   @IBAction private func filteringAction(_ sender: UIButton) {
      //      WallPapers.shared.myWallPapers.reverse()
      //
      //      collectionView.reloadData()
      //   }
      
      //   @IBAction func presentingView(_ sender: UIButton) {
      //      isPresenting = !isPresenting
      //
      //      collectionView.reloadData()
      //   }
      
      //   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      //      guard let cell = sender as? UICollectionViewCell,
      //         let selectIndex = collectionView.indexPath(for: cell) else { return }
      //      let itemAt = selectIndex.item
      //      guard let vc = segue.destination as? DetailImageViewController else { return }
      //
      //      if isPresenting {
      //         let datas = WallPapers.shared.myWallPapers
      ////         let count = datas.count
      ////         let start = itemAt + 9 < count ? itemAt : count - 10
      ////         let end = itemAt + 9 < count ? start + 10 : count
      ////         let current = itemAt + 9 < count ? 0 : 10 - (count - itemAt)
      //         vc.datas = Array(datas[start ..< end])
      //      } else {
      //         let datas = WallPapers.shared.tags[itemAt]
      //         vc.datas = datas.result
      //      }
      //   }
      
      // 네트워크 추적 해제
      deinit {
         reachability?.stopNotifier()
         reachability = nil
      }
   }
   
   //extension MainViewController: UICollectionViewDataSource {
   //   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   //      return isPresenting ? WallPapers.shared.myWallPapers.count : WallPapers.shared.tags.count
   //   }
   //
   //   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   //      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallPapeerCollectionViewCell.identifier, for: indexPath) as? WallPapeerCollectionViewCell else { fatalError() }
   //      var target: MyWallPaper
   //
   //      if isPresenting {
   //         target = WallPapers.shared.myWallPapers[indexPath.row]
   //         cell.tagConfigure(info: nil, isHidden: isPresenting)
   //      } else {
   //         target = WallPapers.shared.tags[indexPath.row].result[0]
   //         cell.tagConfigure(info: WallPapers.shared.tags[indexPath.row].info, isHidden: isPresenting)
   //      }
   //
   //      if let image = target.image {
   //         cell.wallpaperImageView.image = image
   //      } else {
   //         cell.configure(info: target)
   //      }
   //
   //
   //
   //      return cell
   //   }
   //
   //   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
   //      if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
   //                                                                      withReuseIdentifier: HeaderCollectionReusableView.identifier,
   //                                                                      for: indexPath) as? HeaderCollectionReusableView {
   //
   //         header.configure()
   //
   //         return header
   //      }
   //      fatalError()
   //   }
   //}
   
   extension MainViewController: UICollectionViewDelegate {
}
