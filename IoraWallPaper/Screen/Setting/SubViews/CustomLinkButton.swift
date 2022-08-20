//
//  CustomLinkButton.swift
//  IoraWallPaper
//
//  Created by wargi on 2022/08/20.
//  Copyright © 2022 sangwook park. All rights reserved.
//

import SwiftUI

struct CustomLinkButton: View {
    let title: String
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .tint(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct CustomLinkButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomLinkButton(title: "Hello") {
            
        }
    }
}
