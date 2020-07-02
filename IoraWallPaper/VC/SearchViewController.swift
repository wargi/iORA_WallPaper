//
//  SearchViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/23.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController, ViewModelBindableType {
   @IBOutlet private weak var searchBar: UISearchBar!
   @IBOutlet private weak var tableView: UITableView!
   @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
   @IBOutlet private weak var backButton: UIButton!
   var viewModel: SearchViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   func bindViewModel() {
      backButton.rx.action = viewModel.popAction
      
      viewModel.filterd
         .bind(to: tableView.rx.items(cellIdentifier: "tagCell")) { row, tag, cell in
            cell.textLabel?.text = tag
      }
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
