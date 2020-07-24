//
//  SettingViewController.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/20.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import MessageUI

typealias IndexTuple = (Int, Int)
enum CellStyle {
   case about
   case goBlog
   case goInsta
   case feedback
   case review
   case none
}

extension CellStyle {
   static func get(indexPath: IndexPath) -> CellStyle {
      switch (indexPath.section, indexPath.row) {
      case (0, 0):
         return .about
      case (1, 0):
         return .goBlog
      case (1, 1):
         return .goInsta
      case (2, 0):
         return .feedback
      case (2, 1):
         return .review
      default:
         return .none
      }
   }
}

class SettingTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   // 앱스토어 연결
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let cellStyle = CellStyle.get(indexPath: indexPath)
      switch cellStyle {
      case .about:
         if let aboutVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AboutSettingViewController.identifier) as? AboutSettingViewController {
            self.navigationController?.pushViewController(aboutVC, animated: true)
         }
         
      case .goBlog:
         if let blogURL = URL(string: "https://blog.naver.com/iorastudio") {
            if UIApplication.shared.canOpenURL(blogURL) {
               UIApplication.shared.open(blogURL,
                                         options: [:],
                                         completionHandler: nil)
            }
         }
      case .goInsta:
         // 인스타그램으로 이동
         if let instaURL = URL(string: "https://instagram.com/iora_studio?igshid=1erlpx3rebg7b") {
            if UIApplication.shared.canOpenURL(instaURL) {
               UIApplication.shared.open(instaURL,
                                         options: [:],
                                         completionHandler: nil)
            }
         }
      case .feedback:
         let composeVC = MFMailComposeViewController()
         composeVC.mailComposeDelegate = self
         // Configure the fields of the interface.
         composeVC.setToRecipients(["wkahdla12346@gmail.com"])
         composeVC.setSubject("iORA Feedback")
         composeVC.setMessageBody("""
                                  
                                  
                                  
                                  ===========================
                                  - App Version: 1.0.0
                                  """, isHTML: false)
         
         // Present the view controller modally.
         self.present(composeVC, animated: true, completion: nil)
      case .review:
         let id = "1518747131"
         if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(id)?ls=1&mt=8&action=write-review"), UIApplication.shared.canOpenURL(reviewURL) {
            // 유효한 URL인지 검사
            if UIApplication.shared.canOpenURL(reviewURL) {
               UIApplication.shared.open(reviewURL,
                                         options: [:],
                                         completionHandler: nil)
            }
         }
      case .none:
         break
      }
   }
   
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      switch result {
      case .sent, .cancelled, .saved:
         controller.dismiss(animated: true, completion: nil)
      case .failed:
         controller.dismiss(animated: true, completion: nil)
      default:
         break
      }
   }
}
