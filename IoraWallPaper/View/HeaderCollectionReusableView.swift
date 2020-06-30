//
//  HeaderCollectionReusableView.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/30.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
   static let identifier = "HeaderCollectionReusableView"
   @IBOutlet private weak var collectionView: UICollectionView!
   @IBOutlet private weak var pageControl: UIPageControl!
   
   required init?(coder: NSCoder) {
      super.init(coder: coder)
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
   }
   
   func configure() {
      collectionView.delegate = self
      collectionView.dataSource = self
      
      collectionView.layer.cornerRadius = 20
      
      pageControl.numberOfPages = 2
      let scale: CGFloat = 1
      pageControl.transform = CGAffineTransform(scaleX: scale, y: scale)
      
      for dot in pageControl.subviews {
         dot.transform = CGAffineTransform(scaleX: scale, y: scale)
      }
   }
}

extension HeaderCollectionReusableView: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 2
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else { fatalError() }
      
      let image = indexPath.row == 0 ? UIImage(named: "banner") : UIImage(named: "banner2")
      
      cell.configure(image: image)
      
      return cell
   }
}

extension HeaderCollectionReusableView: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return collectionView.bounds.size
   }
}

extension HeaderCollectionReusableView: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      // 인스타그램으로 이동
      if indexPath.row == 0, let url = URL(string: "https://instagram.com/iora_studio?igshid=1erlpx3rebg7b") {
         if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url,
                                      options: [:],
                                      completionHandler: nil)
         } // 블로그로 이동
      } else if indexPath.row == 1, let url = URL(string: "https://blog.naver.com/iorastudio") {
         if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url,
                                      options: [:],
                                      completionHandler: nil)
         }
      }
   }
}

extension HeaderCollectionReusableView: UIScrollViewDelegate {
   func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
      pageControl.updateCurrentPageDisplay()
   }
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let width = collectionView.bounds.size.width
      let x = collectionView.contentOffset.x + (width / 2.0)
      let newPage = Int(x / width)
      
      if pageControl.currentPage != newPage {
         pageControl.currentPage = newPage
      }
   }
}
