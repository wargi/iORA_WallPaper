//
//  DetailViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/10.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController {
   // 상단 버튼
   @IBOutlet private weak var backButton: UIButton!
   @IBOutlet private weak var calendarButton: UIButton!
   @IBOutlet private weak var previewButton: UIButton!
   @IBOutlet private weak var saveButton: UIButton!
   @IBOutlet private weak var shareButton: UIButton!
   // 페이지 컨트롤
   @IBOutlet private weak var pageControl: UIPageControl!
   // 디테일 컬렉션 뷰
   @IBOutlet private weak var collectionView: UICollectionView!
   private var fromTap = false
   // 페이지 데이터 목록
   public var datas: [MyWallPaper] = []
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      configure()
      setImageAndColor(brightness: datas[0].wallpaper.brightness)
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let info = datas[pageControl.currentPage]
      
      if let showVC = segue.destination as? ShowPreViewController  {
         showVC.info = info
      } else if let calVC = segue.destination as? CalendarViewController {
         calVC.info = info
      }
   }
   
   // 앱 기본 설정
   func configure() {
      pageControl.numberOfPages = datas.count
      let scale: CGFloat = 1
      pageControl.transform = CGAffineTransform(scaleX: scale, y: scale)
      
      for dot in pageControl.subviews {
         dot.transform = CGAffineTransform(scaleX: scale, y: scale)
      }
      
      datas.forEach { info in
         if info.image == nil {
            WallPapers.shared.imageDownload(info: info) { (image) in
               info.image = image
            }
         }
      }
   }
   
   // 이미지 설정 및 버튼 컬러 설정
   func setImageAndColor(brightness: Int) {
      let color = WallPapers.shared.getColor(brightness: brightness)
      
      let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
      let calendarImage = UIImage(named: "calendar")?.withRenderingMode(.alwaysTemplate)
      let previewImage = UIImage(named: "preview")?.withRenderingMode(.alwaysTemplate)
      let downloadImage = UIImage(named: "download")?.withRenderingMode(.alwaysTemplate)
      let shareImage = UIImage(named: "share")?.withRenderingMode(.alwaysTemplate)
      
      backButton.imageView?.tintColor = color
      calendarButton.imageView?.tintColor = color
      previewButton.imageView?.tintColor = color
      saveButton.imageView?.tintColor = color
      shareButton.imageView?.tintColor = color
      
      backButton.setImage(backImage, for: .normal)
      calendarButton.setImage(calendarImage, for: .normal)
      previewButton.setImage(previewImage, for: .normal)
      saveButton.setImage(downloadImage, for: .normal)
      shareButton.setImage(shareImage, for: .normal)
   }
   
   //MARK: Button Action
   // 파일 다운로드
   @IBAction private func downlaodAction(_ sender: UIButton) {
      guard let image = datas[pageControl.currentPage].image else { return }
      WallPapers.shared.imageFileDownload(image: image)
      present(WallPapers.shared.downloadAlert(), animated: true) {
         self.dismiss(animated: true, completion: nil)
      }
   }
   
   // Share Action
   @IBAction private func shareAction(_ sender: UIButton) {
      guard let image = datas[pageControl.currentPage].image else { return }
      
      let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
      print(activityVC)
      
      present(activityVC, animated: true, completion: nil)
   }
   
   // Page Change Action
   @IBAction func pageChange(_ sender: UIPageControl) {
      fromTap = true
      
      let indexPath = IndexPath(item: sender.currentPage, section: 0)
      collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
      setImageAndColor(brightness: datas[sender.currentPage].wallpaper.brightness)
   }
   
   
   // Close Action
   @IBAction func popAction() {
      navigationController?.popViewController(animated: true)
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
      
      let width = scrollView.bounds.size.width
      let x = scrollView.contentOffset.x + (width / 2.0)
      let newPage = Int(x / width)
      
      if pageControl.currentPage != newPage {
         pageControl.currentPage = newPage
         setImageAndColor(brightness: datas[newPage].wallpaper.brightness)
      }
   }
}

//MARK: UICollectionView DataSource & Delegate
extension DetailImageViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return datas.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as? DetailCollectionViewCell else { fatalError("Invalid Cell") }
      
      let target = datas[indexPath.row]
      cell.configure(info: target)
      
      return cell
   }
}

extension DetailImageViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height - 0.1)
   }
}
