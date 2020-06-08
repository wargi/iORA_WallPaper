//
//  ViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/08.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
   @IBOutlet private weak var collectionView: UICollectionView!
   var wallpapers: [UIImage?] = [UIImage(named: "Life_is_sample"), UIImage(named: "Palette")]
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
}

extension MainViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return wallpapers.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallPapeerCollectionViewCell.identifier, for: indexPath) as? WallPapeerCollectionViewCell else {
         fatalError("Not Found Cell")
      }
      guard let image = wallpapers[indexPath.row] else { fatalError("image is nil") }
      
      cell.prepare(image: image)
      
      return cell
   }
}

extension MainViewController: UICollectionViewDelegate {
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let width = (UIScreen.main.bounds.size.width - 5) / 2
      print(UIScreen.main.bounds.size)
      
      
      return CGSize(width: width, height: width * 2)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 5
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 5
   }
}
