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
   @IBOutlet private weak var imageView: UIImageView!
   // 상단 버튼
   @IBOutlet private weak var closeButton: UIButton!
   @IBOutlet private weak var closeView: UIView!
   @IBOutlet private weak var downloadButton: UIButton!
   @IBOutlet private weak var downloadView: UIView!
   @IBOutlet private weak var displayTimeLabel: UILabel!
   @IBOutlet private weak var displayDateLabel: UILabel!
   
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
         .subscribe(onNext: { empty in
            let alert = PrepareForSetUp.shared.completedAlert(handler: { _ in
               PrepareForSetUp.shared.imageFileDownload(image: self.viewModel.wallpaper.image)
               self.viewModel.closeAction.inputs.onNext(empty)
            })
//            self.present(alert, animated: true, completion: nil)
            
            return empty
         })
         .disposed(by: rx.disposeBag)
      
      closeButton.rx.action = viewModel.closeAction
   }
}
