//
//  AboutView.swift
//  IoraWallPaper
//
//  Created by wargi on 2022/08/20.
//  Copyright © 2022 sangwook park. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Image("banner2")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.75)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contact")
                        .font(.nanumGothicBold(size: 18))
                        .tint(.mainColor)
                    Text("iorastudio@naver.com")
                        .tint(.primary)
                }
                .padding([.leading, .trailing], 20)
                .padding([.top, .bottom], 26)
                
                Capsule()
                    .frame(height: 1)
                    .foregroundColor(Color(uiColor: .systemGray5))
                    .padding([.leading, .trailing], 20)
                
                Button {
                    openCustomURL(with: "https://instagram.com/_hi_sophie_?igshid=ig4zt52eaf1l")
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Design")
                            .font(.nanumGothicBold(size: 18))
                            .tint(.primary)
                        Text("Sophie")
                            .font(.nanumGothic(size: 16))
                            .tint(.primary)
                        HStack(spacing: 4) {
                            Image("instagram")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .tint(.primary)
                            Text("_" + "hi_sophie" + "_")
                                .font(.nanumGothic(size: 16))
                                .tint(.primary)
                        }
                    }
                }
                .padding([.leading, .trailing], 20)
                .padding([.top, .bottom], 26)
                
                Capsule()
                    .frame(height: 1)
                    .foregroundColor(Color(uiColor: .systemGray5))
                    .padding([.leading, .trailing], 20)
                
                Button {
                    openCustomURL(with: "https://www.github.com/wargi")
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("iOS Developer")
                            .font(.nanumGothicBold(size: 18))
                            .tint(.primary)
                        Text("Wargi")
                            .font(.nanumGothic(size: 16))
                            .tint(.primary)
                        HStack(spacing: 4) {
                            Image("github")
                                .resizable()
                                .frame(width: 26, height: 26)
                                .tint(.primary)
                            Text("github.com/wargi")
                                .font(.nanumGothic(size: 16))
                                .tint(.primary)
                        }
                    }
                }
                .padding([.leading, .trailing], 20)
                .padding([.top, .bottom], 26)
            }
        }
        .navigationTitle("About iORA")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//MARK: - Function
extension AboutView {
    func openCustomURL(with urlString: String) {
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
    }
}
