//
//  ViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/08.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources

class MainViewController: UIViewController, ViewModelBindableType {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // 상단 UI
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var notConnectView: UIView!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var viewModel: MainViewModel!
    var imageOperations: [IndexPath: ImageLoadOpertaion] = [:]
    var downloadQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetUp()
        configure()
    }
    
    func bindViewModel() {
        do {
            try viewModel.reachability?.startNotifier()
        } catch {
            print(error.localizedDescription)
        }
        
        // 네트워크 사용 가능 상태 일 때
        viewModel.reachability?.whenReachable = { reachability in
            self.collectionView.isHidden = false
            self.dataLoad()
        }
        
        // 네트워크 사용 불가능 상태 일 때
        viewModel.reachability?.whenUnreachable = { _ in
            self.collectionView.isHidden = true
        }
        
        viewModel.presentWallpapers
            .subscribe(onNext: {
                self.viewModel.wallpapers = $0
                self.dataLoad()
            })
            .disposed(by: rx.disposeBag)
        
        // 메인리스트 정렬 액션
        filterButton.rx.tap
            .subscribe(onNext: {
                self.viewModel.reverse = !self.viewModel.reverse
                self.viewModel.presentWallpapers.onNext(self.viewModel.wallpapers.reversed())
            })
            .disposed(by: rx.disposeBag)
        
        collectionView.rx.itemSelected
            .map { $0.item }
            .map { index -> [MyWallPaper] in
                self.collectionView.deselectItem(at: IndexPath(item: index, section: 0), animated: true)
                var result: [MyWallPaper]
                
                let wallpapers = self.viewModel.wallpapers
                let temp = index + 9 < wallpapers.count ? wallpapers[index ... index+9] : wallpapers[index...]
                result = Array(temp)
                
                return result
            }
            .map { self.viewModel.showDetailVC(wallpapers: $0) }
            .subscribe(onNext: { [weak self] opVC in
                guard let strongSelf = self,
                      let vc = opVC else { return }
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: rx.disposeBag)
        
        searchButton.rx.tap
            .map { self.viewModel.showSearchVC() }
            .subscribe(onNext: { [weak self] opVC in
                guard let strongSelf = self,
                      let vc = opVC else { return }
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: rx.disposeBag)
    }
    
    // 기본 설정
    func configure() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dataLoad))
        notConnectView.addGestureRecognizer(tap)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(dataLoad), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    // 데이타 로드
    @objc func dataLoad() {
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    func collectionViewSetUp() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let screenWidth = UIScreen.main.bounds.size.width
            var width = screenWidth - 20
            var height = width * 0.75
            
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.headerReferenceSize = CGSize(width: width, height: height)
            
            width = (screenWidth - 30) / 2
            height = PrepareForSetUp.shared.displayType == .retina ? width * 1.77 : width * 2.16
            
            layout.itemSize = CGSize(width: width, height: height)
        }
    }
    
    // 네트워크 추적 해제
    deinit {
        viewModel.reachability?.stopNotifier()
        viewModel.reachability = nil
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.wallpapers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallPaperCollectionViewCell.identifier, for: indexPath) as? WallPaperCollectionViewCell else { return UICollectionViewCell() }
        
        let wallpaper = viewModel.wallpapers[indexPath.item]
        cell.wallpaper = wallpaper
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: HeaderCollectionReusableView.identifier,
                                                                           for: indexPath) as? HeaderCollectionReusableView else { return UICollectionViewCell() }
        
        header.configure()
        
        return header
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let op = imageOperations[indexPath] {
            op.cancel()
            imageOperations.removeValue(forKey: indexPath)
        }
    }
}
