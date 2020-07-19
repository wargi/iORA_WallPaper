//
//  SearchViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/23.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Action

class SearchViewController: UIViewController {
   @IBOutlet private weak var searchBar: UISearchBar!
   @IBOutlet private weak var tableView: UITableView!
   @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
   @IBOutlet private weak var backButton: UIButton!
   var viewModel: SearchViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setSearchBarPlaceholder()
   }
   
   func bindViewModel() {
      WallPapers.shared.tagSubject
         .map { $0 }
         .subscribe(onNext: {
            self.viewModel.tags = $0
            self.viewModel.list = $0.list.map { $0.info.name }
            self.viewModel.filterd.onNext(self.viewModel.list)
         })
         .disposed(by: self.rx.disposeBag)
      
      backButton.rx.tap
         .subscribe(onNext: { _ in
            self.navigationController?.popViewController(animated: true)
         })
         .disposed(by: rx.disposeBag)
      
      viewModel.filterd
         .bind(to: tableView.rx.items(cellIdentifier: "tagCell")) { row, tagStr, cell in
            cell.textLabel?.text = tagStr
      }
      .disposed(by: rx.disposeBag)
      
      Observable.zip(tableView.rx.modelSelected(String.self), tableView.rx.itemSelected)
         .do(onNext: { [unowned self] (_, indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
         })
         .map { $0.0 }
         .bind(to: viewModel.searchResultAction.inputs)
         .disposed(by: rx.disposeBag)
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      NotificationCenter.default.addObserver(self,
                                             selector: #selector(self.keyWillShow(noti:)),
                                             name: UIResponder.keyboardWillShowNotification,
                                             object: nil)
      
      searchBar.becomeFirstResponder()
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      searchBar.resignFirstResponder()
   }
   
   @objc func keyWillShow(noti: Notification) {
      guard let keyboardHeight = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
      
      tableViewBottomConstraint.constant = keyboardHeight
   }
   
   func setSearchBarPlaceholder() {
      // SearchBar text
      let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
      
      // SearchBar placeholder
      let labelInsideUISearchBar = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
      
      switch UIScreen.main.bounds.width {
      case let width where width < 375:
         labelInsideUISearchBar?.font = UIFont(name: "NanumSquareRoundR", size: 10)
      case let width where width == 375:
         labelInsideUISearchBar?.font = UIFont(name: "NanumSquareRoundR", size: 12)
      default:
         labelInsideUISearchBar?.font = UIFont(name: "NanumSquareRoundR", size: 14)
      }
   }
}

extension SearchViewController: UISearchBarDelegate {
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      if searchText.lowercased().isEmpty {
         viewModel.filterd.onNext(viewModel.list)
      } else {
         viewModel.filterd.onNext(viewModel.list.filter({ tag -> Bool in
            let tmp: NSString = tag as NSString
            let range = tmp.range(of: searchText, options: .caseInsensitive)
            return range.location != NSNotFound
         }))
      }
   }
}
