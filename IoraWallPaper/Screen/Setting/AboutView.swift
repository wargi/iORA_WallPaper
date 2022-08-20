//
//  AboutIORA.swift
//  IoraWallPaper
//
//  Created by wargi on 2022/08/20.
//  Copyright © 2022 sangwook park. All rights reserved.
//

import SwiftUI

struct AboutIORA: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Image("banner2")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.75)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contact")
                        .font(.custom("NanumGothicBold", size: 18))
                        .tint(.mainColor)
                    
                    Text("iorastudio@naver.com")
                        .tint(.primary)
                    Capsule()
                        .frame(height: 1)
                        .foregroundColor(Color(uiColor: .systemGray5))
                        .padding([.top, .bottom])
                }
                .padding()
            }
        }
        .navigationTitle("About iORA")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutIORA_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutIORA()
        }
    }
}
