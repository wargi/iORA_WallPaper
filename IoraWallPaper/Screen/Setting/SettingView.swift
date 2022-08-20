//
//  SettingView.swift
//  IoraWallPaper
//
//  Created by wargi on 2022/08/20.
//  Copyright © 2022 sangwook park. All rights reserved.
//

import SwiftUI
import MessageUI

struct SettingView: View {
    @State var composeResult: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingFeedback = false
    
    var body: some View {
        List {
            Section {
                ZStack {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Text("")
                    }
                    .opacity(0)
                    
                    HStack {
                        Text("About iORA")
                            .tint(.black)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            Section {
                CustomLinkButton(title: "iORA Blog") {
                    openCustomURL(with: "https://blog.naver.com/iorastudio")
                }
                CustomLinkButton(title: "iORA Instagram") {
                    openCustomURL(with: "https://instagram.com/iora_studio?igshid=1erlpx3rebg7b")
                }
            }
            Section {
                CustomLinkButton(title: "App Feedback") {
                    isShowingFeedback.toggle()
                }
                CustomLinkButton(title: "App Review") {
                    let id = "1518747131"
                    openCustomURL(with: "itms-apps://itunes.apple.com/app/itunes-u/id\(id)?ls=1&mt=8&action=write-review")
                }
                HStack {
                    Text("App Version")
                    Spacer()
                    Text("1.2")
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle("Setting")
        .navigationBarTitleDisplayMode(.inline)
        .font(.custom("NanumGothic", fixedSize: 15))
        .sheet(isPresented: $isShowingFeedback) {
            MailView(isShowing: $isShowingFeedback, result: $composeResult)
        }
    }
    
    //MARK: - Functions
    func openCustomURL(with urlString: String) {
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url)
    }
    
    func openFeedback() {
        if MFMailComposeViewController.canSendMail() {
            
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
