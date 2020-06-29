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
   
   required init?(coder: NSCoder) {
      super.init(coder: coder)
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
   }
   
   func configure() {
      collectionView.delegate = self
      collectionView.dataSource = self
   }
}

extension HeaderCollectionReusableView: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else { fatalError() }
      
      let image = UIImage(named: "banner")
      print(image)
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
   
}
