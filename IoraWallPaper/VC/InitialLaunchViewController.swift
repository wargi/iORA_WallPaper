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
   @IBOutlet private weak var pageControl: UIPageControl!
   @IBOutlet private weak var startButton: UIButton!
   var viewModel: InitialLaunchViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      startButton.layer.cornerRadius = 27.5
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
            let _ = $0.x
            if self.pageControl.currentPage == self.pageControl.numberOfPages - 1 {
               self.startButton.isUserInteractionEnabled = true
               UIView.animate(withDuration: 0.3) {
                  self.startButton.alpha = 1.0
               }
            } else {
               self.startButton.isUserInteractionEnabled = false
               UIView.animate(withDuration: 0.1) {
                  self.startButton.alpha = 0
               }
            }
         })
         .map { $0.x + (self.collectionView.bounds.width / 2.0) }
         .map { Int($0 / self.collectionView.bounds.width) }
         .bind(to: pageControl.rx.currentPage)
         .disposed(by: rx.disposeBag)
      
      startButton.rx.tap
         .map { self.viewModel.showMainVC() }
         .subscribe(onNext: {
            self.present($0, animated: true, completion: nil)
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
