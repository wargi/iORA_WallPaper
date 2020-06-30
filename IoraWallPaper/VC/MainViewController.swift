//
//  ViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/08.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ViewModelBindableType {
   @IBOutlet private weak var collectionView: UICollectionView!
   
   // 상단 UI
   @IBOutlet private weak var navigationView: UIView!
   @IBOutlet private weak var notConnectView: UIView!
   @IBOutlet private weak var presentingButton: UIButton!
   private var reachability: Reachability?
   var isPresenting = true
   
   var viewModeel: MainViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      configure()
      dataLoad()
   }
   
   func bindViewModel() {
      
   }
   
   // 기본 설정
   func configure() {
      NotificationCenter.default.addObserver(self, selector: #selector(self.dataLoad), name: NSNotification.Name(rawValue: "didFinishLaunchingWithOptions"), object: nil)
      
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
   
   //MARK: Button Action
   
   @IBAction private func filteringAction(_ sender: UIButton) {
      WallPapers.shared.datas.reverse()
      
      collectionView.reloadData()
   }
   
   @IBAction func presentingView(_ sender: UIButton) {
      isPresenting = !isPresenting
      
      collectionView.reloadData()
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      guard let cell = sender as? UICollectionViewCell,
         let selectIndex = collectionView.indexPath(for: cell) else { return }
      let itemAt = selectIndex.item
      guard let vc = segue.destination as? DetailImageViewController else { return }
      
      if isPresenting {
         let datas = WallPapers.shared.datas
         let count = datas.count
         let start = itemAt + 9 < count ? itemAt : count - 10
         let end = itemAt + 9 < count ? start + 10 : count
         let current = itemAt + 9 < count ? 0 : 10 - (count - itemAt)
         vc.datas = Array(datas[start ..< end])
      } else {
         let datas = WallPapers.shared.tags[itemAt]
         vc.datas = datas.result
      }
   }
   
   // 네트워크 추적 해제
   deinit {
      reachability?.stopNotifier()
      reachability = nil
   }
}

extension MainViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return isPresenting ? WallPapers.shared.datas.count : WallPapers.shared.tags.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallPapeerCollectionViewCell.identifier, for: indexPath) as? WallPapeerCollectionViewCell else { fatalError() }
      var target: MyWallPaper
      
      if isPresenting {
         target = WallPapers.shared.datas[indexPath.row]
         cell.tagConfigure(title: nil, isHidden: isPresenting)
      } else {
         target = WallPapers.shared.tags[indexPath.row].result[0]
         cell.tagConfigure(title: WallPapers.shared.tags[indexPath.row].tag, isHidden: isPresenting)
      }
      
      if let image = target.image {
         cell.wallpaperImageView.image = image
      } else {
         cell.configure(info: target)
      }
      
      
      
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                      withReuseIdentifier: HeaderCollectionReusableView.identifier,
                                                                      for: indexPath) as? HeaderCollectionReusableView {
         
         header.configure()
         
         return header
      }
      fatalError()
   }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      var width: CGFloat
      
      if isPresenting {
         width = (collectionView.bounds.width - 30) / 2
         return CGSize(width: width, height: width * 2)
      } else {
         width = (collectionView.bounds.width - 30) * 0.9
         return CGSize(width: width, height: width * 1.7)
      }
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      if isPresenting {
         return 10
      } else {
         return 20
      }
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      if isPresenting {
         return 10
      } else {
         return 25
      }
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
      let width = collectionView.bounds.width
      if isPresenting {
         return CGSize(width: width, height: 300)
      } else {
         return CGSize(width: width, height: 0)
      }
   }
}

extension MainViewController: UICollectionViewDelegate {
}
