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
   var images: [UIImage?] = [UIImage(named: "Life_is_sample"),
                             UIImage(named: "Palette"),
                             UIImage(named: "Under_the_Sea")]
   var wallpapers: [WallPaper] = [WallPaper(imageName: "", imageURL: "", tag: nil, brightness: 1),
                                  WallPaper(imageName: "", imageURL: "", tag: nil, brightness: 0),
                                  WallPaper(imageName: "", imageURL: "", tag: nil, brightness: 0)]
   
   let titleView: UIView = {
      let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
      let titlabel = UILabel(frame: view.frame)
      titlabel.textAlignment = .center
      titlabel.text = "iORA Studio"
      titlabel.font = .systemFont(ofSize: 20)
      view.addSubview(titlabel)
      return view
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      navigationItem.titleView = titleView
      WallPapers.shared.data = wallpapers
      WallPapers.shared.images = images
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      guard let detailImgVC = segue.destination as? DetailImageViewController,
         let cell = sender as? WallPapeerCollectionViewCell,
         let indexPath = collectionView.indexPath(for: cell) else { fatalError() }
      
      detailImgVC.image = images[indexPath.item]
      detailImgVC.wallPaper = wallpapers[indexPath.item]
   }
   
   @IBAction private func goInsta(_ sender: UIButton) {
      guard let url = URL(string: "https://instagram.com/iora_studio?igshid=1erlpx3rebg7b") else { fatalError("Invalid URL") }
      if UIApplication.shared.canOpenURL(url) {
         UIApplication.shared.open(url,
                                   options: [:],
                                   completionHandler: nil)
      }
   }
   
   
   @IBAction private func goBlog(_ sender: UIButton) {
      guard let url = URL(string: "https://blog.naver.com/iorastudio") else { fatalError("Invalid URL") }
      if UIApplication.shared.canOpenURL(url) {
         UIApplication.shared.open(url,
                                   options: [:],
                                   completionHandler: nil)
      }
   }
}

extension MainViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return images.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallPapeerCollectionViewCell.identifier, for: indexPath) as? WallPapeerCollectionViewCell else {
         fatalError("Not Found Cell")
      }
      guard let image = images[indexPath.row] else { fatalError("image is nil") }
      
      DispatchQueue.global().async {
         cell.prepare(image: image)
      }
      
      
      return cell
   }
}

extension MainViewController: UICollectionViewDelegate {
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
   
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let width = (collectionView.bounds.size.width - 15) / 2
      
      return CGSize(width: width, height: width * 2.1654)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 5
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 5
   }
}
