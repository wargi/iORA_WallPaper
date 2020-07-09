//
//  InitialViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/28.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class InitialLaunchViewController: UIViewController, ViewModelBindableType {
   @IBOutlet private weak var collectionView: UICollectionView!
   @IBOutlet private weak var prevButton: UIButton!
   @IBOutlet private weak var nextButton: UIButton!
   @IBOutlet private weak var pageControl: UIPageControl!
   var viewModel: InitialLaunchViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   func bindViewModel() {
      viewModel.imagesSubject
         .bind(to: collectionView.rx.items(cellIdentifier: InitialCollectionViewCell.identifier,
                                           cellType: InitialCollectionViewCell.self)) { (index, image, cell) in
                                             cell.configure(image: image)
                                             
      }
      .disposed(by: rx.disposeBag)
      
      viewModel.imagesSubject
         .map { $0.count }
         .bind(to: pageControl.rx.numberOfPages)
         .disposed(by: rx.disposeBag)
      
      collectionView.rx.contentOffset
         .do(onNext: {
            let width = self.collectionView.bounds.width
            let currentPage = Int($0.x / width)
            if currentPage == 0 {
               self.prevButton.setTitleColor(.lightGray, for: .normal)
               self.prevButton.isEnabled = false
            } else {
               self.prevButton.setTitleColor(.white, for: .normal)
               self.prevButton.isEnabled = true
            }
            
            if currentPage == self.pageControl.numberOfPages - 1 {
               self.nextButton.setTitle("OK", for: .normal)
            } else {
               self.nextButton.setTitle("Next", for: .normal)
               self.nextButton.setTitleColor(.white, for: .normal)
               self.nextButton.isEnabled = true
            }
         })
         .map { $0.x + (self.collectionView.bounds.width / 2.0) }
         .map { Int($0 / self.collectionView.bounds.width) }
         .bind(to: pageControl.rx.currentPage)
         .disposed(by: rx.disposeBag)
      
      prevButton.rx.tap
         .map { self.collectionView.contentOffset.x }
         .subscribe(onNext: {
            let width = self.collectionView.bounds.width
            let currentPage = Int($0 / width)
            
            if currentPage > 0 {
               self.collectionView.scrollToItem(at: IndexPath(item: currentPage - 1, section: 0),
                                                at: .centeredHorizontally,
                                                animated: true)
            }
         })
         .disposed(by: rx.disposeBag)
      
      nextButton.rx.tap
         .map { self.collectionView.contentOffset.x }
         .subscribe(onNext: {
            let width = self.collectionView.bounds.width
            let currentPage = Int($0 / width)
            
            if currentPage < 2 {
               self.collectionView.scrollToItem(at: IndexPath(item: currentPage + 1, section: 0),
                                                at: .centeredHorizontally,
                                                animated: true)
            } else if currentPage == self.pageControl.numberOfPages - 1 {
               UserDefaults.standard.setValue(true, forKey: "isLaunch")
               self.viewModel.okAction()
            }
         })
         .disposed(by: rx.disposeBag)
      
   }
}

//MARK: UICollectionView Delegate
extension InitialLaunchViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height - 0.1)
   }
}

extension InitialLaunchViewController: UICollectionViewDelegate {
   func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
      pageControl.updateCurrentPageDisplay()
   }
}
