//
//  DetailViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/10.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

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
   var viewModel: DetailImageViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      configure()
      collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
   }
   
   func bindViewModel() {
      viewModel.wallpapersSubject
         .map { $0.count }
         .bind(to: pageControl.rx.numberOfPages)
         .disposed(by: rx.disposeBag)
      
      //MARK: Button Action
      previewButton.rx.tap
         .map { self.pageControl.currentPage }
         .bind(to: viewModel.showPreViewAction.inputs)
         .disposed(by: rx.disposeBag)
         
      
      // 파일 다운로드
      saveButton.rx.tap
         .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
         .map { self.pageControl.currentPage }
         .subscribe(onNext: {
            self.present(PrepareForSetUp.shared.completedAlert(), animated: true) {
               self.dismiss(animated: true, completion: nil)
            }
            self.viewModel.downloadAction.inputs.onNext($0)
         })
         .disposed(by: rx.disposeBag)
      
      // 파일 공유
      shareButton.rx.tap
         .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
         .map { self.pageControl.currentPage }
         .map { self.viewModel.shareAction(currentIndex: $0) }
         .subscribe(onNext: { self.present($0, animated: true, completion: nil) })
         .disposed(by: rx.disposeBag)
      
      viewModel.wallpapersSubject
         .bind(to: collectionView.rx.items(cellIdentifier: DetailCollectionViewCell.identifier,
                                           cellType: DetailCollectionViewCell.self)) { item, wallpaper, cell in
         cell.wallPaperImageView.layer.cornerRadius = 30
         cell.wallPaperImageView.layer.masksToBounds = true
         
         cell.layer.masksToBounds = false
         cell.layer.shadowColor = UIColor.black.cgColor
         cell.layer.shadowOpacity = 0.4
         cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
         cell.layer.shadowRadius = 6
         cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds,
                                              cornerRadius: 30).cgPath
         
         if let image = wallpaper.image {
            cell.wallPaperImageView.image = image
         } else {
            cell.configure(info: wallpaper)
         }
      }
      .disposed(by: rx.disposeBag)
      
      backButton.rx.action = viewModel.popAction
   }
   
   // 앱 기본 설정
   func configure() {
      let scale: CGFloat = 0.75
      pageControl.transform = CGAffineTransform(scaleX: scale, y: scale)
      
      for dot in pageControl.subviews {
         dot.transform = CGAffineTransform(scaleX: scale, y: scale)
      }
   }
   
   // Page Change Action
   @IBAction func pageChange(_ sender: UIPageControl) {
      fromTap = true
      
      let indexPath = IndexPath(item: sender.currentPage, section: 0)
      collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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

//MARK: UICollectionView Delegate
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
