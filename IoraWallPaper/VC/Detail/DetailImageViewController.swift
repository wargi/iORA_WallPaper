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
import GoogleMobileAds
import CenteredCollectionView

class DetailImageViewController: UIViewController, ViewModelBindableType {
   static let identifier = "DetailImageViewController"
   var imageOperations: [IndexPath: ImageLoadOpertaion] = [:]
   var downloadQueue = OperationQueue()
   
   // 상단 버튼
   @IBOutlet private weak var backButton: UIButton!
   @IBOutlet private weak var calendarButton: UIButton!
   @IBOutlet private weak var previewButton: UIButton!
   @IBOutlet private weak var saveButton: UIButton!
   // 페이지 컨트롤
   @IBOutlet weak var pageControl: UIPageControl!
   // 디테일 컬렉션 뷰
   @IBOutlet private weak var collectionView: UICollectionView!
   var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
   // 구글 광고
   var rewardedAd: GADRewardedAd?
   
   private var fromTap = false
   var viewModel: DetailImageViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      navigationController?.navigationBar.isHidden = true
      
      rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-4824477530561217/9898668680")
      
      configure()
      
      centeredCollectionViewFlowLayout = (collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout)
      collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
      
      centeredCollectionViewFlowLayout.minimumLineSpacing = 25
      
      var width: CGFloat = 0
      let collectionWidth = UIScreen.main.bounds.size.width
      print(UIScreen.main.bounds)
      switch (UIScreen.main.bounds.size) {
      case CGSize(width: 414.0, height: 896.0): // 11 & pro max
         width = collectionWidth * 0.7
      case CGSize(width: 414.0, height: 736.0):
         width = collectionWidth * 0.7
      case CGSize(width: 375.0, height: 812.0): // 11 pro
         width = collectionWidth * 0.68
      case CGSize(width: 375.0, height: 667.0): // se2 &
         width = collectionWidth * 0.68
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
         .map { self.viewModel.showCalendarVC(index: $0) }
         .subscribe(onNext: {
            self.navigationController?.tabBarController?.present($0, animated: true, completion: nil)
         })
         .disposed(by: rx.disposeBag)
      
      previewButton.rx.tap
         .map { self.pageControl.currentPage }
         .map { self.viewModel.showPreViewVC(index: $0) }
         .subscribe(onNext: {
            self.navigationController?.tabBarController?.present($0, animated: true, completion: nil)
         })
         .disposed(by: rx.disposeBag)
      
      
      // 파일 다운로드
      saveButton.rx.tap
         .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
         .subscribe(onNext: {
            
         })
         .disposed(by: rx.disposeBag)
      
      viewModel.wallpapersSubject
         .bind(to: collectionView.rx.items(cellIdentifier: DetailCollectionViewCell.identifier,
                                           cellType: DetailCollectionViewCell.self)) { item, wallpaper, cell in
                                             cell.configure(info: wallpaper)
      }
      .disposed(by: rx.disposeBag)
      
      backButton.rx.tap
         .subscribe(onNext: { _ in
            self.navigationController?.popViewController(animated: true)
         })
         .disposed(by: rx.disposeBag)
   }
   
   // 앱 기본 설정
   func configure() {
      let scale: CGFloat = 0.6
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
      if let currentCenteredPage = centeredCollectionViewFlowLayout.currentCenteredPage {
         if pageControl.currentPage != currentCenteredPage {
            pageControl.currentPage = currentCenteredPage
         }
      }
   }
}

//MARK: UICollectionView Delegate
extension DetailImageViewController: UICollectionViewDelegateFlowLayout {
}

extension DetailImageViewController: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      guard let cell = cell as? DetailCollectionViewCell,
         let target = cell.info,
         cell.wallPaperImageView.image == nil else { return }
      
      let imageOp = ImageLoadOpertaion(url: PrepareForSetUp.getImageURL(info: target)) { (image) in
         DispatchQueue.main.async {
            cell.display(image: image)
            if cell.info?.image == nil { cell.info?.image = image }
         }
      }
      
      downloadQueue.addOperation(imageOp)
      imageOperations.updateValue(imageOp, forKey: indexPath)
   }
   
   func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      if let op = imageOperations[indexPath] {
         op.cancel()
         imageOperations.removeValue(forKey: indexPath)
      }
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let currentCenteredPage = centeredCollectionViewFlowLayout.currentCenteredPage
      
      if currentCenteredPage != indexPath.item {
         centeredCollectionViewFlowLayout.scrollToPage(index: indexPath.item, animated: true)
      }
   }
}

extension DetailImageViewController: GADRewardedAdDelegate {
   /// Tells the delegate that the user earned a reward.
   func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
      print("Reward received with currency: \(reward.type), amount \(reward.amount).")
      let alert = self.viewModel.downloadAction(index: pageControl.currentPage)
      self.present(alert, animated: true) {
         if alert.title != "Save Fail" {
            alert.dismiss(animated: true, completion: nil)
         }
      }
   }
   /// Tells the delegate that the rewarded ad was presented.
   func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad presented.")
   }
   /// Tells the delegate that the rewarded ad was dismissed.
   func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad dismissed.")
   }
   /// Tells the delegate that the rewarded ad failed to present.
   func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
      print("Rewarded ad failed to present.")
   }
}
