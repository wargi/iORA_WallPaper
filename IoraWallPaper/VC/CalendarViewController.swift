//
//  CalendarViewController.swift
//  IoraWallPaper
//
//  Created by 박소정 on 2020/06/13.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
   
   @IBOutlet private weak var yearLabel: UILabel!
   @IBOutlet private weak var monthLabel: UILabel!
   var emptyCellCount = 0
   let dateArr = ["S", "M", "T", "W", "T", "F", "S"]
   let monthArr = ["January", "February", "March", "April", "May", "June",
                   "July", "August", "September", "October", "November", "December"]
   let calendar = Calendar(identifier: .gregorian)
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      calendarDate()
   }
   
   func calendarDate() {
      var currentDate = Date()
      let year = calendar.component(.year, from: currentDate)
      let month = calendar.component(.month, from: currentDate) + 2
      
      if let date = calendar.date(from: DateComponents(year: year, month: month, day: 1)) {
         currentDate = date
      }
      
      yearLabel.text = "\(year)"
      monthLabel.text = monthArr[month - 1]
      emptyCellCount = calendar.component(.weekday, from: currentDate) - 1
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
         cell.setValue(text: dateArr[indexPath.row])
         cell.dayLabel.font = UIFont(name: "NanumSquareRoundEB", size: 15)
      case (_, let y):
         let dayValue = indexPath.row - emptyCellCount + 1
         y < emptyCellCount ? cell.setValue(text: "") : cell.setValue(text: "\(dayValue)")
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
