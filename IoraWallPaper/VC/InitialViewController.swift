//
//  InitialViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/28.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
   @IBOutlet private weak var collectionView: UICollectionView!
   lazy var images: [UIImage?] = {
      var images = [UIImage?]()
      
      
      return images
   }()
   override func viewDidLoad() {
      super.viewDidLoad()
   }
}

//MARK: UICollectionView DataSource & Delegate
extension InitialViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return images.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InitialCollectionViewCell.identifier,
                                                          for: indexPath) as? InitialCollectionViewCell else { fatalError() }
      
      cell.configure(image: images[indexPath.row])
      
      return cell
   }
}

extension InitialViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height - 0.1)
   }
}
