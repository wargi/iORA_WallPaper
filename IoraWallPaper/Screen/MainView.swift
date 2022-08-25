//
//  MainView.swift
//  IoraWallPaper
//
//  Created by wargi on 2022/08/20.
//  Copyright © 2022 sangwook park. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationView {
                MainListView()
            }
            .tabItem {
                Image("list")
                Text("List")
            }
            
            NavigationView {
                FavoriteView()
            }
            .tabItem {
                Image("tab_star")
                Text("Favorite")
            }
            
            NavigationView {
                CategoriesView()
            }
            .tabItem {
                Image("category")
                Text("Category")
            }
            
            NavigationView {
                SettingView()
            }
            .tabItem {
                Image("setings")
                Text("Setting")
            }
        }
        .accentColor(.mainColor)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
