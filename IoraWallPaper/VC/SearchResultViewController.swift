//
//  SearchResultViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/23.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, ViewModelBindableType {
   @IBOutlet private weak var titleLabel: UILabel!
   @IBOutlet private weak var collectionView: UICollectionView!
   
   var resultWallPapers = [MyWallPaper]()
   var titleString: String?
   var viewModeel: SearchResultViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      configure()
   }
   
   func bindViewModel() {
      
   }
   
   func configure() {
      titleLabel.text = titleString
   }
   
   // 화면 전환 전 데이터 전달
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let detailImgVC = segue.destination as? DetailImageViewController,
         let cell = sender as? WallPapeerCollectionViewCell,
         let indexPath = collectionView.indexPath(for: cell) {
         
         detailImgVC.datas = [resultWallPapers[indexPath.item]]
      }
   }
   
   @IBAction private func popAction(_ sender: UIButton) {
      navigationController?.popViewController(animated: true)
   }
}

extension SearchResultViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return resultWallPapers.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallPapeerCollectionViewCell.identifier, for: indexPath) as? WallPapeerCollectionViewCell else {
         fatalError("Not Found Cell")
      }
      let index = indexPath.item
      
      if let image = resultWallPapers[index].image {
         cell.wallpaperImageView.image = image
      } else {
         cell.configure(info: resultWallPapers[index])
      }
      
      return cell
   }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let width = (collectionView.bounds.size.width - 15) / 2
      
      return CGSize(width: width, height: width * 2)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 5
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 5
   }
}
