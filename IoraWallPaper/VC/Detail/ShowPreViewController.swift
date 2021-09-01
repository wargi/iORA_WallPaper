//
//  ShowPreViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/11.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class ShowPreViewController: UIViewController, ViewModelBindableType {
   static let identifier = "ShowPreViewController"
   
   @IBOutlet private weak var imageView: UIImageView!
   // 상단 버튼
   @IBOutlet private weak var closeButton: UIButton!
   @IBOutlet private weak var closeView: UIView!
   @IBOutlet private weak var downloadButton: UIButton!
   @IBOutlet private weak var downloadView: UIView!
   @IBOutlet private weak var displayTimeLabel: UILabel!
   @IBOutlet private weak var displayDateLabel: UILabel!
   var disposeBag = DisposeBag()
   
   var viewModel: ShowPreViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   func bindViewModel() {
      viewModel.info
         .map { $0.image }
         .bind(to: imageView.rx.image)
         .disposed(by: rx.disposeBag)
      
      viewModel.info
         .map { $0.wallpaper.brightness }
         .map { $0 == 0 ? UIColor.white : UIColor.black }
         .subscribe(onNext: {
            // 이미지 설정 및 버튼 컬러 설정
            self.closeView.layer.cornerRadius = 17.5
            self.downloadView.layer.cornerRadius = 17.5
            
            self.displayTimeLabel.textColor = $0
            self.displayDateLabel.textColor = $0
         })
         .disposed(by: rx.disposeBag)

      // 파일 다운로드 Action
      downloadButton.rx.tap
         .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
         .subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            guard let alert = strongSelf.viewModel.downloadAction() else { return }
            if alert.title == "Save Success :)" {
               let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                strongSelf.dismiss(animated: true, completion: nil)
               }
               alert.addAction(okAction)
            }
            
            strongSelf.present(alert, animated: true, completion: nil)
         })
         .disposed(by: rx.disposeBag)
      
      closeButton.rx.tap
         .subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
         })
         .disposed(by: rx.disposeBag)
   }
}
