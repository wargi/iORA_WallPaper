//
//  CategoryCardView.swift
//  IoraWallPaper
//
//  Created by wargi on 2022/08/20.
//  Copyright © 2022 sangwook park. All rights reserved.
//

import SwiftUI

struct CategoryCardView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("banner")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            Color.black
                .opacity(0.4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Spring")
                    .foregroundColor(.white)
                    .font(.nanumGothicExtraBold(size: 25))
                
                Text("How do you overcome the servere cold weather?")
                    .lineLimit(2)
                    .foregroundColor(.white)
                    .font(.nanumGothicBold(size: 15))
            }
            .padding([.top, .leading], 30)
            .padding(.trailing, 16)
        }
        .ignoresSafeArea()
    }
}

struct CategoryCardView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCardView()
            .previewLayout(.sizeThatFits)
    }
}
