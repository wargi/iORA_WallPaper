//
//  AboutSettingViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/23.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit

class AboutSettingViewController: UIViewController {
   static let identifier = "AboutSettingViewController"
   @IBOutlet private weak var tableView: UITableView!
   override func viewDidLoad() {
      super.viewDidLoad()
   }
}

extension AboutSettingViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 3
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      switch (indexPath.section, indexPath.row) {
      case (0, 0):
         let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
         
         return cell
      default:
         guard let cell = tableView.dequeueReusableCell(withIdentifier: AboutTableViewCell.identifier,
                                                        for: indexPath) as? AboutTableViewCell else { fatalError() }
         
         cell.titleLabel.text = indexPath.row == 1 ? "Design" : "iOS Developer"
         cell.nameLabel.text = indexPath.row == 1 ? "Sophie" : "Wargi"
         cell.linkLabel.text = indexPath.row == 1 ? "_hi_sophie_" : "github.com/wargi"
         
         return cell
      }
   }
   func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
      return UIScreen.main.bounds.size.width * 0.75
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      switch indexPath.row {
      case 0:
         return 105.5
      default:
         return 120
      }
   }
}

extension AboutSettingViewController: UITableViewDelegate {
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if indexPath.row == 1 {
         if let url = URL(string: "https://instagram.com/_hi_sophie_?igshid=ig4zt52eaf1l") {
            if UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url,
                                         options: [:],
                                         completionHandler: nil)
            }
         }
      } else if indexPath.row == 2 {
         if let url = URL(string: "https://www.github.com/wargi") {
            if UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url,
                                         options: [:],
                                         completionHandler: nil)
            }
         }
      }
   }
}
