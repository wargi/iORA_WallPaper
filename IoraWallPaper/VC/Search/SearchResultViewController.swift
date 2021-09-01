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
    var imageOperations: [IndexPath: ImageLoadOpertaion] = [:]
    var downloadQueue = OperationQueue()
    
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
        if let wallpaers = try? viewModel.wallpapers.value() {
            wallpaers.forEach {
                print($0.wallpaper.imageName)
            }   
        }
        
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: rx.disposeBag)
       
        backButton.rx.tap
            .subscribe(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: rx.disposeBag)
    }
}

extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = try? viewModel.wallpapers.value().count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let wallpapers = try? viewModel.wallpapers.value(),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallPaperCollectionViewCell.identifier, for: indexPath) as? WallPaperCollectionViewCell else { return UICollectionViewCell() }
        
        let wallpaper = wallpapers[indexPath.row]
        cell.wallpaper = wallpaper
        
        return cell
    }
}

extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: IndexPath(item: indexPath.item, section: 0), animated: true)
        
        guard let wallpaper = try? viewModel.wallpapers.value()[indexPath.row],
              let vc = viewModel.showDetailVC(wallpaper: wallpaper) else { return }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? WallPaperCollectionViewCell,
              let target = cell.wallpaper,
              let url = PrepareForSetUp.getImageURL(info: target),
              cell.wallpaperImageView.image == nil else { return }
        
        cell.isLoading = true
        
        let imageOp = ImageLoadOpertaion(url: url) { (image) in
            DispatchQueue.main.async {
                cell.isLoading = false
                cell.display(image: image)
            }
        }
        
        downloadQueue.addOperation(imageOp)
        imageOperations.updateValue(imageOp, forKey: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - 30) / 2
        
        let height = PrepareForSetUp.shared.displayType == .retina ? width * 1.77 : width * 2.16
        return CGSize(width: width, height: height)
    }
}
