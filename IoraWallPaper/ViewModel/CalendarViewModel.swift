//
//  CalendarViewModel.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/25.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class CalendarViewModel {
   let info: MyWallPaper
   let infoSubject: BehaviorSubject<MyWallPaper>
   
   var colorSub: BehaviorSubject<UIColor>
   
   var yearSub = BehaviorSubject<String>(value: "")
   var monthSub = BehaviorSubject<String>(value: "")
   var daySub = BehaviorSubject<[String]>(value: [])
   
   private let calendar = Calendar.autoupdatingCurrent
   private var currentDate = Date()
   
   func paletteAction() -> CocoaAction {
      return CocoaAction {
         guard let currentColor = try? self.colorSub.value() else { fatalError("invalid color") }
         
         switch currentColor {
         case .white:
            self.colorSub.onNext(.black)
         case .black:
            self.colorSub.onNext(.gray)
         default:
            self.colorSub.onNext(.white)
         }
         
         return Observable.empty()
      }
   }
   
   // 달력 생성
   func calendarCreate(year: Int, month: Int) {
      guard let date = calendar.date(from: DateComponents(year: year, month: month, day: 1)) else { return }
      let dateArr = ["S", "M", "T", "W", "T", "F", "S"]
      let monthArr = ["January", "February", "March", "April", "May", "June",
                      "July", "August", "September", "October", "November", "December"]
      
      var emptyCell = [String]()
      var dayArr = [String]()
      
      yearSub.onNext("\(year)")
      monthSub.onNext(monthArr[month - 1])
      
      let leaf = year % 4 == 0 ? year % 100 != 0 || year % 400 == 0 ? 29 : 28 : 28
      let lastDayArr = [31, leaf, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
      
      for _ in 0 ..< calendar.component(.weekday, from: date) - 1 {
         emptyCell.append("")
      }
      
      for i in 1 ... lastDayArr[month - 1] {
         dayArr.append("\(i)")
      }
      
      daySub.onNext(dateArr + emptyCell + dayArr)
   }
   
   // 현재 달, 다음 달, 2달 뒤 달력 표시 알럿
   func showAlertCalendarList() -> Observable<UIAlertController> {
      let year = calendar.component(.year, from: currentDate)
      let month = calendar.component(.month, from: currentDate)
      
      let showYear = month + 1 > 12 || month + 2 > 12 ? year + 1 : year
      
      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      
      let currentMonthString = month < 10 ? "0\(month)" : "\(month)"
      
      let nextMonth = month + 1 == 13 ? 1 : month + 1
      let nextMonthString = nextMonth < 10 ? "0\(nextMonth)" : "\(nextMonth)"
      
      let twoMonthLater = month + 2 == 13 ? 1 : month + 2 == 14 ? 2 : month + 2
      let twoMonthLaterString = twoMonthLater < 10 ? "0\(twoMonthLater)" : "\(twoMonthLater)"
      
      let showCurrentMonthAction = UIAlertAction(title: "\(year) / \(currentMonthString)", style: .default) { (_) in
         self.calendarCreate(year: year, month: month)
      }
      
      let ShowNextMonthAction = UIAlertAction(title: "\(showYear) / \(nextMonthString)", style: .default) { (_) in
         self.calendarCreate(year: showYear, month: nextMonth)
      }
      
      let Show2MonthLaterAction = UIAlertAction(title: "\(showYear) / \(twoMonthLaterString)", style: .default) { (_) in
         self.calendarCreate(year: showYear, month: twoMonthLater)
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      
      alert.addAction(showCurrentMonthAction)
      alert.addAction(ShowNextMonthAction)
      alert.addAction(Show2MonthLaterAction)
      alert.addAction(cancelAction)
      
      return Observable.just(alert)
   }
   
   init(info: MyWallPaper) {
      self.info = info
      self.infoSubject = BehaviorSubject<MyWallPaper>(value: info)
      
      colorSub = BehaviorSubject(value: PrepareForSetUp.shared.getColor(brightness: self.info.wallpaper.brightness))
      
      calendarCreate(year: calendar.component(.year, from: currentDate),
                     month: calendar.component(.month, from: currentDate))
   }
}
