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
   @IBOutlet weak var pageControl: UIPageControl!
   // 디테일 컬렉션 뷰
   @IBOutlet private weak var collectionView: UICollectionView!
   
   private var startingScrollingOffset = CGPoint.zero
   
   
   private var fromTap = false
   // 페이지 데이터 목록
   public var datas: [MyWallPaper] = []
   var viewModeel: DetailImageViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      configure()
      collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
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
      let scale: CGFloat = 0.75
      pageControl.transform = CGAffineTransform(scaleX: scale, y: scale)
      
      for dot in pageControl.subviews {
         dot.transform = CGAffineTransform(scaleX: scale, y: scale)
      }
      
      datas.forEach { info in
         if info.image == nil {
            PrepareForSetUp.shared.imageDownload(info: info) { (image) in
               info.image = image
            }
         }
      }
   }
   
   func snapToCenter() {
      let centerPoint = view.convert(view.center, to: collectionView)
      guard let centerIndexPath = collectionView.indexPathForItem(at: centerPoint) else { return }
      collectionView.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
   }
   
   //MARK: Button Action
   // 파일 다운로드
   @IBAction private func downlaodAction(_ sender: UIButton) {
      guard let image = datas[pageControl.currentPage].image else { return }
      PrepareForSetUp.shared.imageFileDownload(image: image)
      present(PrepareForSetUp.shared.completedAlert(), animated: true) {
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
      
      let width = collectionView.bounds.size.width
      let x = collectionView.contentOffset.x + (width / 2.0)
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
      
      cell.wallPaperImageView.layer.cornerRadius = 30
      cell.wallPaperImageView.layer.masksToBounds = true
      
      cell.layer.masksToBounds = false
      cell.layer.shadowColor = UIColor.black.cgColor
      cell.layer.shadowOpacity = 0.4
      cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
      cell.layer.shadowRadius = 6
      cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds,
                                           cornerRadius: 30).cgPath
      
      if let image = target.image {
         cell.wallPaperImageView.image = image
      } else {
         cell.configure(info: target)
      }
      
      
      return cell
   }
}

extension DetailImageViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: collectionView.bounds.size.width * 0.70, height: collectionView.bounds.size.height - 20)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 10,
                          left: collectionView.bounds.width * 0.15,
                          bottom: 10,
                          right: collectionView.bounds.width * 0.15)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      let width = collectionView.bounds.size.width
      return width * 0.1
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      let width = collectionView.bounds.size.width
      return width * 0.1
   }
}
