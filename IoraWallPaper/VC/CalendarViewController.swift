//
//  CalendarViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/13.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

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

   
   // 컬러 관련
   public lazy var color = PrepareForSetUp.shared.getColor(brightness: info?.wallpaper.brightness)
   var viewModel: CalendarViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      configure()
   }
   
   func bindViewModel() {
      // 이미지 설정 및 버튼 컬러 설정
      viewModel.infoSubject
         .map { $0.image }
         .bind(to: imageView.rx.image)
         .disposed(by: rx.disposeBag)
      
      viewModel.colorSub
         .subscribe(onNext: {
            self.yearLabel.textColor = $0
            self.monthLabel.textColor = $0
            self.lineView.backgroundColor = $0
         })
         .disposed(by: rx.disposeBag)
      
      viewModel.yearSub
         .bind(to: yearLabel.rx.text)
         .disposed(by: rx.disposeBag)
      
      viewModel.monthSub
         .bind(to: monthLabel.rx.text)
         .disposed(by: rx.disposeBag)
      
      viewModel.daySub
         .bind(to: collectionView.rx.items(cellIdentifier: DayCollectionViewCell.identifier,
                                           cellType: DayCollectionViewCell.self)) { row, str, cell in
                                             
         self.viewModel.colorSub
            .subscribe(onNext: { cell.dayLabel.textColor = $0 })
            .disposed(by: self.rx.disposeBag)
                                             
         cell.configure(str)
         if row < 7 { cell.dayLabel.font = UIFont(name: "NanumSquareRoundEB", size: 15) }
         }
         .disposed(by: rx.disposeBag)
      
      //MARK: Button Action
      // Calendar 색깔 변경
      paletteButton.rx.action = viewModel.paletteAction()
      
      Observable.combineLatest(calendarButton.rx.tap, viewModel.showAlertCalendarList())
         .map { $0.1 }
         .subscribe(onNext: {
            self.present($0, animated: true, completion: nil)
         })
         .disposed(by: rx.disposeBag)
      
      // 파일 다운로드 Action
      downloadButton.rx.tap
         .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
         .subscribe(onNext: { empty in
            let alert = PrepareForSetUp.shared.completedAlert(handler: { _ in
               self.isHiddenDisplayUI(isHidden: true)
               PrepareForSetUp.shared.screenImageDownload()
               self.isHiddenDisplayUI(isHidden: false)
               self.viewModel.closeAction.inputs.onNext(empty)
            })
            self.present(alert, animated: true, completion: nil)
            
            return empty
         })
         .disposed(by: rx.disposeBag)
      
      closeButton.rx.action = viewModel.closeAction
   }
   
   // 기본 설정
   func configure() {
      let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
      stackView.addGestureRecognizer(pan)
      
      self.closeView.layer.cornerRadius = 17.5
      self.downloadView.layer.cornerRadius = 17.5
      self.calendarView.layer.cornerRadius = 17.5
      self.paletteView.layer.cornerRadius = 17.5
      
      if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
         layout.minimumLineSpacing = 0
         layout.minimumInteritemSpacing = 0
      }
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
   
   // 화면에 표시된 UI 숨김
   func isHiddenDisplayUI(isHidden: Bool) {
      closeView.isHidden = isHidden
      downloadView.isHidden = isHidden
      paletteView.isHidden = isHidden
      calendarView.isHidden = isHidden
   }
}


//MARK: UICollectionView Delegate
// UICollectionView Delegate
extension CalendarViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 200/7, height: 200/7)
   }
}
