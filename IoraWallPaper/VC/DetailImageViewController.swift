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
import CenteredCollectionView

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
   var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
   
   private var fromTap = false
   var viewModel: DetailImageViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      configure()
      
      centeredCollectionViewFlowLayout = (collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout)
      collectionView.decelerationRate  = UIScrollView.DecelerationRate.fast
      
      centeredCollectionViewFlowLayout.minimumLineSpacing = 20
      
      var width: CGFloat = 0
      let collectionWidth = collectionView.bounds.width

      switch (UIScreen.main.bounds.size) {
      case CGSize(width: 414.0, height: 896.0):
         width = collectionWidth * 0.79
      case CGSize(width: 414.0, height: 736.0):
         width = collectionWidth * 0.8
      case CGSize(width: 375.0, height: 812.0):
         width = collectionWidth * 0.69
      case CGSize(width: 375.0, height: 667.0):
         width = collectionWidth * 0.7
      default:
         width = collectionWidth * 0.6
      }
      
      let height = PrepareForSetUp.shared.displayType == .retina ? width * 1.77 : width * 2.16
      
      centeredCollectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
      
   }
   
   func bindViewModel() {
      viewModel.wallpapersSubject
         .map { $0.count }
         .bind(to: pageControl.rx.numberOfPages)
         .disposed(by: rx.disposeBag)
      
      //MARK: Button Action
      calendarButton.rx.tap
         .map { self.pageControl.currentPage }
         .bind(to: viewModel.showCalendarAction.inputs)
         .disposed(by: rx.disposeBag)
      
      previewButton.rx.tap
         .map { self.pageControl.currentPage }
         .bind(to: viewModel.showPreViewAction.inputs)
         .disposed(by: rx.disposeBag)
      
      
      // 파일 다운로드
      saveButton.rx.tap
         .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
         .map { self.pageControl.currentPage }
         .subscribe(onNext: {
//            self.present(PrepareForSetUp.shared.completedAlert(), animated: true) {
//               self.dismiss(animated: true, completion: nil)
//            }
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
                                             
                                             cell.configure(info: wallpaper)
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
      let width = collectionView.bounds.size.width * 0.7
      let x = collectionView.contentOffset.x + (width / 2.0)
      let newPage = Int(x / width)
      
      if pageControl.currentPage != newPage {
         pageControl.currentPage = newPage
      }
   }
}

//MARK: UICollectionView Delegate
extension DetailImageViewController: UICollectionViewDelegateFlowLayout {
}

extension DetailImageViewController: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     let currentCenteredPage = centeredCollectionViewFlowLayout.currentCenteredPage
      
     if currentCenteredPage != indexPath.item {
       centeredCollectionViewFlowLayout.scrollToPage(index: indexPath.item, animated: true)
     }
   }
}
