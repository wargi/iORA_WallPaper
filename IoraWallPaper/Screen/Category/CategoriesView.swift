//
//  CategoriesView.swift
//  IoraWallPaper
//
//  Created by wargi on 2022/08/20.
//  Copyright © 2022 sangwook park. All rights reserved.
//

import SwiftUI
import Kingfisher

struct CategoriesView: View {
    @ObservedObject var viewModel = CategoriesViewModel()
    
    var body: some View {
        GeometryReader { reader in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.fixed(cardWidth))],
                          alignment: .center,
                          spacing: 30,
                          pinnedViews: []) {
                    ForEach(WallPapers.shared.tags) { category in
                        NavigationLink {
                            ImageCollectionView(wallpapers: category.result)
                        } label: {
                            CategoryCardView(imageURL: PrepareForSetUp.getImageURL(info: category.result.first),
                                             title: category.info.name,
                                             description: category.info.desc)
                            .frame(height: cardHeight)
                            .cornerRadius(20)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .onAppear {
                UIScrollView.appearance().isPagingEnabled = false
            }
        }
        .navigationBarHidden(true)
    }
}

extension CategoriesView {
    var cardWidth: CGFloat {
        return UIScreen.main.bounds.width * 0.78
    }
    
    var cardHeight: CGFloat {
        PrepareForSetUp.shared.displayType == .retina ? cardWidth * 1.77 : cardWidth * 2.16
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
