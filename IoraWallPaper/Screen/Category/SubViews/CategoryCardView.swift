//
//  CategoryCardView.swift
//  IoraWallPaper
//
//  Created by wargi on 2022/08/20.
//  Copyright © 2022 sangwook park. All rights reserved.
//

import SwiftUI
import Kingfisher

struct CategoryCardView: View {
    var imageURL: URL?
    var title: String
    var description: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            GeometryReader { reader in
                KFImage(imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: reader.size.width)
            }
            
            Color.black
                .opacity(0.4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .foregroundColor(.white)
                    .font(.nanumGothicExtraBold(size: 25))
                
                Text(description)
                    .lineLimit(2)
                    .foregroundColor(.white)
                    .font(.nanumGothicBold(size: 15))
                    .multilineTextAlignment(.leading)
            }
            .padding([.top, .leading], 30)
            .padding(.trailing, 16)
        }
    }
}

struct CategoryCardView_Previews: PreviewProvider {
    static var image = Image("banner")
    static var title = "Spring"
    static var description = "How do you overcome the servere cold weather?"
    
    static var previews: some View {
        CategoryCardView(imageURL: nil, title: title, description: description)
            .previewLayout(.sizeThatFits)
    }
}
