//
//  MainListView.swift
//  IoraWallPaper
//
//  Created by wargi on 2022/08/23.
//  Copyright © 2022 sangwook park. All rights reserved.
//

import SwiftUI
import Kingfisher

struct MainListView: View {
    let screenWidth = UIScreen.main.bounds.width
    let cardWidth = (UIScreen.main.bounds.width - 48) / 2
    var cardHeight: CGFloat {
        PrepareForSetUp.shared.displayType == .retina ? cardWidth * 1.77 : cardWidth * 2.16
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            VStack {
                navigationView
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                ScrollView {
                    bannerView
                        .padding(.horizontal, 16)
                    
                    LazyVGrid(columns: [GridItem(.fixed(cardWidth)),
                                        GridItem(.fixed(cardWidth))],
                              alignment: .center,
                              spacing: 16,
                              pinnedViews: []) {
                        ForEach(WallPapers.shared.myWallPapers) { info in
                            NavigationLink {
                                
                            } label: {
                                KFImage(PrepareForSetUp.getImageURL(info: info))
                                    .resizable()
                                    .frame(height: cardHeight)
                                    .cornerRadius(20)
                                    .shadow(radius: 1.0)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

extension MainListView {
    func openCustomURL(with urlString: String) {
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url)
    }
}

extension MainListView {
    var navigationView: some View {
        HStack(alignment: .center) {
            Text("iORA STUDIO")
                .font(.gmarketSansBold(size: 14))
            Spacer()
            
            HStack(spacing: 8) {
                Button {
                    
                } label: {
                    Image("filter")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                
                NavigationLink {
                    SearchView()
                } label: {
                    Image("search")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
        }
    }
    
    var bannerView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            TabView {
                Image("banner2")
                    .resizable()
                    .cornerRadius(20)
                    .onTapGesture {
                        openCustomURL(with: "https://instagram.com/iora_studio?igshid=1erlpx3rebg7b")
                    }
                
                Image("banner")
                    .resizable()
                    .cornerRadius(20)
                    .onTapGesture {
                        openCustomURL(with: "https://blog.naver.com/iorastudio")
                    }
            }
            .frame(width: screenWidth - 32, height: screenWidth * 0.75)
            .tabViewStyle(.page)
            .indexViewStyle(.page)
        }
        .onAppear {
            UIScrollView.appearance().isPagingEnabled = true
        }
    }
}

struct MainListView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
