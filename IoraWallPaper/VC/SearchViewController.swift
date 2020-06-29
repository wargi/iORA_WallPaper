//
//  SearchViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/23.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, ViewModelBindableType {
   @IBOutlet private weak var searchBar: UISearchBar!
   @IBOutlet private weak var tableView: UITableView!
   @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
   var filtered: [String] = []
   var list: [String] = []
   var viewModeel: SearchViewModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      configure()
      NotificationCenter.default.addObserver(self,
                                             selector: #selector(self.configure),
                                             name: NSNotification.Name(rawValue: "didFinishLaunchingWithOptions"),
                                             object: nil)
      
   }
   
   func bindViewModel() {
      
   }
   
   @objc func configure() {
      WallPapers.shared.tags.forEach { list.append($0.tag) }
      filtered = list
      
      tableView.reloadData()
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
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      guard let resultVC = segue.destination as? SearchResultViewController,
         let cell = sender as? UITableViewCell,
         let index = tableView.indexPath(for: cell)?.row else { return }
      
      let tag = filtered[index]
      
      let wallpapers = WallPapers.shared.datas.filter { $0.wallpaper.tag.contains(tag) }
      
      resultVC.resultWallPapers = wallpapers
      resultVC.titleString = tag
   }
   
   @IBAction private func popAction(_ sender: UIButton) {
      navigationController?.popViewController(animated: true)
   }
   
   @objc func keyWillShow(noti: Notification) {
      guard let keyboardHeight = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
      
      tableViewBottomConstraint.constant = keyboardHeight
   }
}

extension SearchViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return filtered.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath)
      
      cell.textLabel?.text = filtered[indexPath.row]
      
      return cell
   }
}

extension SearchViewController: UISearchBarDelegate {
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      filtered = searchText.lowercased().isEmpty ? list : list.filter({ tag -> Bool in
         let tmp: NSString = tag as NSString
         let range = tmp.range(of: searchText, options: .caseInsensitive)
         return range.location != NSNotFound
      })
      
      tableView.reloadData()
   }
}
