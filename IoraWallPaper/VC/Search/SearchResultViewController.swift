//
//  SearchResultViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/23.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class SearchResultViewController: UIViewController, ViewModelBindableType {
    static let identifier = "SearchResultViewController"
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var backButton: UIButton!
    
    var resultWallPapers = [MyWallPaper]()
    var viewModel: SearchResultViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
        }
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel.wallpapers
            .bind(to: collectionView.rx.items(cellIdentifier: WallPaperCollectionViewCell.identifier,
                                              cellType: WallPaperCollectionViewCell.self)) { item, wallpaper, cell in
                if let image = wallpaper.image {
                    cell.wallpaperImageView.image = image
                } else {
                    //            cell.configure(info: wallpaper)
                }
            }
            .disposed(by: rx.disposeBag)
        
        // 화면 전환 전 데이터 전달
        Observable.zip(collectionView.rx.modelSelected(MyWallPaper.self), collectionView.rx.itemSelected)
            .do(onNext: { self.collectionView.deselectItem(at: $0.1, animated: true) })
            .map { $0.0 }
            .map { self.viewModel.showDetailVC(wallpaper: $0) }
            .subscribe(onNext: { [weak self] opVC in
                guard let strongSelf = self,
                      let vc = opVC else { return }
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: rx.disposeBag)
        
        backButton.rx.tap
            .subscribe(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: rx.disposeBag)
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - 30) / 2
        
        let height = PrepareForSetUp.shared.displayType == .retina ? width * 1.77 : width * 2.16
        return CGSize(width: width, height: height)
    }
}
