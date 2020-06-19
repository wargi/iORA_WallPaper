//
//  ViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/08.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
   // 이미지 리스트 컬렉션 뷰
   @IBOutlet private weak var collectionView: UICollectionView!
   // 상단 UI
   @IBOutlet private weak var navigationView: UIView!
   @IBOutlet private weak var notConnectView: UIView!
   private var reachability: Reachability?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      configure()
      dataLoad()
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
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(self.dataLoad))
      notConnectView.addGestureRecognizer(tap)
      
      let refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: #selector(dataLoad), for: .valueChanged)
      collectionView.refreshControl = refreshControl
   }
   
   // 데이타 로드
   @objc func dataLoad() {
      WallPapers.shared.dataDownload {
         DispatchQueue.main.async {
            for _ in 0 ..< WallPapers.shared.data.count {
               WallPapers.shared.images.append(nil)
            }
            
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
         }
      }
   }
   
   // 화면 전환 전 데이터 전달
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      guard let detailImgVC = segue.destination as? DetailImageViewController,
         let cell = sender as? WallPapeerCollectionViewCell,
         let indexPath = collectionView.indexPath(for: cell) else { fatalError() }
      
      detailImgVC.image = WallPapers.shared.images[indexPath.item]
      detailImgVC.info = WallPapers.shared.data[indexPath.item]
   }
   
   //MARK: 버튼 액션
   // 인스타그램으로 이동
   @IBAction private func goInsta(_ sender: UIButton) {
      guard let url = URL(string: "https://instagram.com/iora_studio?igshid=1erlpx3rebg7b") else { fatalError("Invalid URL") }
      if UIApplication.shared.canOpenURL(url) {
         UIApplication.shared.open(url,
                                   options: [:],
                                   completionHandler: nil)
      }
   }
   
   // 블로그로 이동
   @IBAction private func goBlog(_ sender: UIButton) {
      guard let url = URL(string: "https://blog.naver.com/iorastudio") else { fatalError("Invalid URL") }
      if UIApplication.shared.canOpenURL(url) {
         UIApplication.shared.open(url,
                                   options: [:],
                                   completionHandler: nil)
      }
   }
   
   // 네트워크 추적 해제
   deinit {
      reachability?.stopNotifier()
      reachability = nil
   }
}

//MARK: UICollectionView DataSource & Delegate
extension MainViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return WallPapers.shared.data.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallPapeerCollectionViewCell.identifier, for: indexPath) as? WallPapeerCollectionViewCell else {
         fatalError("Not Found Cell")
      }
      
      if let image = WallPapers.shared.images[indexPath.item] {
         cell.wallpaperImageView.image = image
      } else {
         cell.configure(itemAt: indexPath.item)
      }
      
      
      return cell
   }
}

extension MainViewController: UICollectionViewDelegate {
}

extension MainViewController: UICollectionViewDelegateFlowLayout {   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let width = (collectionView.bounds.size.width - 15) / 2
      
      return CGSize(width: width, height: width * 2)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 5
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 5
   }
}
