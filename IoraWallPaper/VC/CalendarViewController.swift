//
//  CalendarViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/13.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, ViewModelBindableType {
   // 배경화면 관련
   public var info: MyWallPaper?
   @IBOutlet private weak var imageView: UIImageView!
   
   // 상단 버튼
   @IBOutlet private weak var paletteButton: UIButton!
   @IBOutlet private weak var paletteView: UIView!
   @IBOutlet private weak var calendarButton: UIButton!
   @IBOutlet private weak var calendarView: UIView!
   @IBOutlet private weak var downloadButton: UIButton!
   @IBOutlet private weak var downloadView: UIView!
   @IBOutlet private weak var closeButton: UIButton!
   @IBOutlet private weak var closeView: UIView!
   
   // 달력 관련
   @IBOutlet private weak var collectionView: UICollectionView!
   @IBOutlet private weak var stackView: UIStackView!
   @IBOutlet private weak var yearLabel: UILabel!
   @IBOutlet private weak var monthLabel: UILabel!
   @IBOutlet private weak var lineView: UIView!
   
   private let dateArr = ["S", "M", "T", "W", "T", "F", "S"]
   private let monthArr = ["January", "February", "March", "April", "May", "June",
                           "July", "August", "September", "October", "November", "December"]
   private let calendar = Calendar(identifier: .gregorian)
   private var currentDate = Date()
   private var emptyCellCount = 0
   private lazy var year = calendar.component(.year, from: currentDate)
   private lazy var month = calendar.component(.month, from: currentDate)
   
   // 컬러 관련
   public lazy var color = PrepareForSetUp.shared.getColor(brightness: info?.wallpaper.brightness)
   var viewModel: CalendarViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      configure()
      setImageAndColor()
      calendarCreate(year: year, month: month)
   }
   
   func bindViewModel() {
      
   }
   
   // 기본 설정
   func configure() {
      let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
      stackView.addGestureRecognizer(pan)
   }
   
   // 이미지 설정 및 버튼 컬러 설정
   func setImageAndColor() {
      guard let image = info?.image else { return }
      imageView.image = image

      yearLabel.textColor = color
      monthLabel.textColor = color
      lineView.backgroundColor = color

      closeView.layer.cornerRadius = 17.5
      downloadView.layer.cornerRadius = 17.5
      calendarView.layer.cornerRadius = 17.5
      paletteView.layer.cornerRadius = 17.5
   }
   
   // 달력 이동 관련 팬 제스쳐
   @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
      guard let targetView = sender.view else { return }
      
      let centerX = Int(view.center.x)
      let centerY = Int(view.center.y)
      let targetCenterX = Int(targetView.center.x)
      let targetCenterY = Int(targetView.center.y)
      
      let translation = sender.translation(in: view)
      let velocity = sender.velocity(in: view)
      
      if targetCenterX == centerX && targetCenterY == centerY &&
         abs(velocity.x) < 654 && abs(velocity.y) < 654 {
      } else if targetCenterX == centerX && abs(velocity.x) < 654 {
         targetView.center.y += translation.y
      } else if targetCenterY == centerY && abs(velocity.y) < 654 {
         targetView.center.x += translation.x
      } else {
         targetView.center.x += translation.x
         targetView.center.y += translation.y
      }
      
      sender.setTranslation(.zero, in: view)
   }
   
   // 달력 생성
   func calendarCreate(year: Int, month: Int) {
      if let date = calendar.date(from: DateComponents(year: year, month: month, day: 1)) {
         currentDate = date
      }
      
      yearLabel.text = "\(year)"
      monthLabel.text = monthArr[month - 1]
      emptyCellCount = calendar.component(.weekday, from: currentDate) - 1
      collectionView.reloadData()
   }
   
   // 화면에 표시된 UI 숨김
   func isHiddenDisplayUI(isHidden: Bool) {
      closeButton.isHidden = isHidden
      downloadButton.isHidden = isHidden
      paletteButton.isHidden = isHidden
      calendarButton.isHidden = isHidden
   }
   
   
   //MARK: Button Action
   // Calendar 색깔 변경
   @IBAction private func paletteAction(_ sender: UIButton) {
      guard let currentColor = yearLabel.textColor else { return }
      var nextColor: UIColor
      
      switch currentColor {
      case .white:
         nextColor = .black
      case .black:
         nextColor = .gray
      default:
         nextColor = .white
      }
      
      yearLabel.textColor = nextColor
      monthLabel.textColor = nextColor
      lineView.backgroundColor = nextColor
      color = nextColor
      collectionView.reloadData()
   }
   
   // 현재 달, 다음 달, 2달 뒤 달력 표시 알럿
   @IBAction private func showAlertCalendarList(_ sender: UIButton) {
      let showYear = month + 1 > 12 || month + 2 > 12 ? year + 1 : year
      
      let currentMonthString = month < 10 ? "0\(month)" : "\(month)"
      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      let showCurrentMonthAction = UIAlertAction(title: "\(year) / \(currentMonthString)", style: .default) { (_) in
         self.calendarCreate(year: self.year, month: self.month)
      }
      
      let nextMonth = month + 1 == 13 ? 1 : month + 1
      let nextMonthString = nextMonth < 10 ? "0\(nextMonth)" : "\(nextMonth)"
      let ShowNextMonthAction = UIAlertAction(title: "\(showYear) / \(nextMonthString)", style: .default) { (_) in
         self.calendarCreate(year: showYear, month: nextMonth)
      }
      
      let twoMonthLater = month + 2 == 13 ? 1 : month + 2 == 14 ? 2 : month + 2
      let twoMonthLaterString = twoMonthLater < 10 ? "0\(twoMonthLater)" : "\(twoMonthLater)"
      let Show2MonthLaterAction = UIAlertAction(title: "\(showYear) / \(twoMonthLaterString)", style: .default) { (_) in
         self.calendarCreate(year: showYear, month: twoMonthLater)
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      
      alert.addAction(showCurrentMonthAction)
      alert.addAction(ShowNextMonthAction)
      alert.addAction(Show2MonthLaterAction)
      alert.addAction(cancelAction)
      
      present(alert, animated: true, completion: nil)
   }
   
   // 다운로드 액션
   @IBAction private func downloadAction(_ sender: UIButton) {
      isHiddenDisplayUI(isHidden: true)
      PrepareForSetUp.shared.screenImageDownload()
      isHiddenDisplayUI(isHidden: false)
      
      present(PrepareForSetUp.shared.completedAlert(handler: { (_) in
         self.dismiss(animated: true, completion: nil)
      }), animated: true, completion: nil)
   }
   
   // Close Action
   @IBAction private func closeAction(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
}


//MARK: UICollectionView DataSource & Delegate
// UICollectionView DataSource
extension CalendarViewController: UICollectionViewDataSource {
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 2
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return section == 0 ? 7 : 31 + emptyCellCount
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.identifier,
         for: indexPath) as? DayCollectionViewCell else { fatalError("Not Match Cell") }
      
      switch (indexPath.section, indexPath.row) {
      case (0, _):
         cell.configure(dateArr[indexPath.row], color)
         cell.dayLabel.font = UIFont(name: "NanumSquareRoundEB", size: 15)
      case (_, let y):
         let dayValue = indexPath.row - emptyCellCount + 1
         y < emptyCellCount ? cell.configure("", color) : cell.configure("\(dayValue)", color)
      }
      
      return cell
   }
}

// UICollectionView Delegate
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
