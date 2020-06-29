//
//  DetailViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/10.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController, ViewModelBindableType {
   // 상단 버튼
   @IBOutlet private weak var backButton: UIButton!
   @IBOutlet private weak var calendarButton: UIButton!
   @IBOutlet private weak var previewButton: UIButton!
   @IBOutlet private weak var saveButton: UIButton!
   @IBOutlet private weak var shareButton: UIButton!
   // 페이지 컨트롤
   @IBOutlet private weak var pageControl: UIPageControl!
   // 디테일 컬렉션 뷰
   @IBOutlet private weak var collectionView: UICollectionView!
   private var fromTap = false
   // 페이지 데이터 목록
   public var datas: [MyWallPaper] = []
   var viewModeel: DetailImageViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      configure()
   }
   
   func bindViewModel() {
      
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let info = datas[pageControl.currentPage]
      
      if let showVC = segue.destination as? ShowPreViewController  {
         showVC.info = info
      } else if let calVC = segue.destination as? CalendarViewController {
         calVC.info = info
      }
   }
   
   // 앱 기본 설정
   func configure() {
      pageControl.numberOfPages = datas.count
      let scale: CGFloat = 1
      pageControl.transform = CGAffineTransform(scaleX: scale, y: scale)
      
      for dot in pageControl.subviews {
         dot.transform = CGAffineTransform(scaleX: scale, y: scale)
      }
      
      datas.forEach { info in
         if info.image == nil {
            WallPapers.shared.imageDownload(info: info) { (image) in
               info.image = image
            }
         }
      }
   }
   
   //MARK: Button Action
   // 파일 다운로드
   @IBAction private func downlaodAction(_ sender: UIButton) {
      guard let image = datas[pageControl.currentPage].image else { return }
      WallPapers.shared.imageFileDownload(image: image)
      present(WallPapers.shared.downloadAlert(), animated: true) {
         self.dismiss(animated: true, completion: nil)
      }
   }
   
   // Share Action
   @IBAction private func shareAction(_ sender: UIButton) {
      guard let image = datas[pageControl.currentPage].image else { return }
      
      let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
      print(activityVC)
      
      present(activityVC, animated: true, completion: nil)
   }
   
   // Page Change Action
   @IBAction func pageChange(_ sender: UIPageControl) {
      fromTap = true
      
      let indexPath = IndexPath(item: sender.currentPage, section: 0)
      collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
   }
   
   
   // Close Action
   @IBAction func popAction() {
      navigationController?.popViewController(animated: true)
   }
}

//MARK: Page Control / ScrollView Delegate
extension DetailImageViewController: UIScrollViewDelegate {
   func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
      fromTap = false
      pageControl.updateCurrentPageDisplay()
   }
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      guard !fromTap else { return }
      
      let width = scrollView.bounds.size.width
      let x = scrollView.contentOffset.x + (width / 2.0)
      let newPage = Int(x / width)
      
      if pageControl.currentPage != newPage {
         pageControl.currentPage = newPage
      }
   }
}

//MARK: UICollectionView DataSource & Delegate
extension DetailImageViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return datas.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as? DetailCollectionViewCell else { fatalError("Invalid Cell") }
      
      let target = datas[indexPath.row]
      cell.configure(info: target)
      
      return cell
   }
}

extension DetailImageViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: collectionView.bounds.size.width - 20, height: collectionView.bounds.size.height - 20)
   }
}
