//
//  CalendarViewController.swift
//  IoraWallPaper
//
//  Created by 박소정 on 2020/06/13.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Photos

class CalendarViewController: UIViewController {
   var image: UIImage?
   var brightness: Int?
   lazy var color: UIColor = {
      guard let brightness = brightness else { return .black }
      return brightness == 0 ? .white : .black
   }()
   @IBOutlet private weak var imageView: UIImageView!
   @IBOutlet private weak var paletteButton: UIButton!
   @IBOutlet private weak var calendarButton: UIButton!
   @IBOutlet private weak var downloadButton: UIButton!
   @IBOutlet private weak var closeButton: UIButton!
   @IBOutlet private weak var yearLabel: UILabel!
   @IBOutlet private weak var monthLabel: UILabel!
   @IBOutlet private weak var collectionView: UICollectionView!
   var emptyCellCount = 0
   let dateArr = ["S", "M", "T", "W", "T", "F", "S"]
   let monthArr = ["January", "February", "March", "April", "May", "June",
                   "July", "August", "September", "October", "November", "December"]
   let calendar = Calendar(identifier: .gregorian)
   var currentDate = Date()
   lazy var year = calendar.component(.year, from: currentDate)
   lazy var month = calendar.component(.month, from: currentDate)
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setImageAndTintColor()
      calendarDate(year: year, month: month)
   }
   
   func setImageAndTintColor() {
      guard let image = image else { return }
      imageView.image = image
      
      let closeImage = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
      let paletteImage = UIImage(named: "palette")?.withRenderingMode(.alwaysTemplate)
      let calendarImage = UIImage(named: "calendar")?.withRenderingMode(.alwaysTemplate)
      let downImage = UIImage(named: "pDownload")?.withRenderingMode(.alwaysTemplate)
      
      yearLabel.textColor = color
      monthLabel.textColor = color
      closeButton.imageView?.tintColor = color
      paletteButton.imageView?.tintColor = color
      calendarButton.imageView?.tintColor = color
      downloadButton.imageView?.tintColor = color
      
      closeButton.setImage(closeImage, for: .normal)
      paletteButton.setImage(paletteImage, for: .normal)
      calendarButton.setImage(calendarImage, for: .normal)
      downloadButton.setImage(downImage, for: .normal)
   }
   
   func calendarDate(year: Int, month: Int) {
      if let date = calendar.date(from: DateComponents(year: year, month: month, day: 1)) {
         currentDate = date
      }
      
      yearLabel.text = "\(year)"
      monthLabel.text = monthArr[month - 1]
      emptyCellCount = calendar.component(.weekday, from: currentDate) - 1
      collectionView.reloadData()
   }
   
   @IBAction private func paletteAction(_ sender: UIButton) {
      let calendarColor: UIColor = color == UIColor.black ? .white : .black
      
      yearLabel.textColor = calendarColor
      monthLabel.textColor = calendarColor
      color = calendarColor
      collectionView.reloadData()
   }
   
   @IBAction private func showAlertCalendarList(_ sender: UIButton) {
      let showYear = month + 1 > 12 || month + 2 > 12 ? year + 1 : year
      
      let currentMonthString = month < 10 ? "0\(month)" : "\(month)"
      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      let showCurrentMonthAction = UIAlertAction(title: "\(year) / \(currentMonthString)", style: .default) { (_) in
         self.calendarDate(year: self.year, month: self.month)
      }
      
      let nextMonth = month + 1 == 13 ? 1 : month + 1
      let nextMonthString = nextMonth < 10 ? "0\(nextMonth)" : "\(nextMonth)"
      let ShowNextMonthAction = UIAlertAction(title: "\(showYear) / \(nextMonthString)", style: .default) { (_) in
         self.calendarDate(year: showYear, month: nextMonth)
      }
      
      let twoMonthLater = month + 2 == 13 ? 1 : month + 2 == 14 ? 2 : month + 2
      let twoMonthLaterString = twoMonthLater < 10 ? "0\(twoMonthLater)" : "\(twoMonthLater)"
      let Show2MonthLaterAction = UIAlertAction(title: "\(showYear) / \(twoMonthLaterString)", style: .default) { (_) in
         self.calendarDate(year: showYear, month: twoMonthLater)
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      
      alert.addAction(showCurrentMonthAction)
      alert.addAction(ShowNextMonthAction)
      alert.addAction(Show2MonthLaterAction)
      alert.addAction(cancelAction)
      
      present(alert, animated: true, completion: nil)
   }
   
   @IBAction private func downloadAction(_ sender: UIButton) {
      closeButton.isHidden = true
      paletteButton.isHidden = true
      calendarButton.isHidden = true
      downloadButton.isHidden = true
      
      guard let layer = UIApplication.shared.keyWindow?.layer else { return }
      var screenImage: UIImage?
      let scale = UIScreen.main.scale
      UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
      guard let context = UIGraphicsGetCurrentContext() else { return }
      layer.render(in: context)
      screenImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      guard let image = screenImage else { return }
      PHPhotoLibrary.shared().savePhoto(image: image, albumName: "iORA")
      
      closeButton.isHidden = false
      paletteButton.isHidden = false
      calendarButton.isHidden = false
      downloadButton.isHidden = false
   }
   
   @IBAction private func closeAction(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
}

extension CalendarViewController: UICollectionViewDataSource {
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 2
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return section == 0 ? 7 : 31 + emptyCellCount
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.identifier,
                                                          for: indexPath) as? DayCollectionViewCell else {
                                                            fatalError("Not Match Cell")
      }
      
      switch (indexPath.section, indexPath.row) {
      case (0, _):
         cell.setValue(text: dateArr[indexPath.row], textColor: color)
         cell.dayLabel.font = UIFont(name: "NanumSquareRoundEB", size: 15)
      case (_, let y):
         let dayValue = indexPath.row - emptyCellCount + 1
         y < emptyCellCount ? cell.setValue(text: "", textColor: color) : cell.setValue(text: "\(dayValue)", textColor: color)
      }
      
      return cell
   }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let width = 200 / 7
      return CGSize(width: width, height: width)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 0
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 0
   }
}
