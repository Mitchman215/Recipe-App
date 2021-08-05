//
//  RecipeTabView.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 6/28/21.
//

import SwiftUI

struct RecipeTabView: View {
    
    @State var selectedTab = Constants.featuredTab
    
    var body: some View {
        
        TabView (selection: $selectedTab) {
            
            RecipeFeaturedView()
                .tabItem {
                    tabItemDisplay(image: "star.fill", text: "Featured")
                }
                .tag(Constants.featuredTab)
            
            RecipeCategoryView(selectedTab: $selectedTab)
                .tabItem {
                    tabItemDisplay(image: "square.grid.2x2", text: "Categories")
                }
                .tag(Constants.categoriesTab)
            
            RecipeListView()
                .tabItem {
                    tabItemDisplay(image: "list.bullet", text: "List")
                }
                .tag(Constants.listTab)
            
            AddRecipeView()
                .tabItem {
                    tabItemDisplay(image: "plus.circle", text: "Add")
                }
                .tag(Constants.addTab)
        }
        .environmentObject(RecipeModel())
        
    }
    
    private func tabItemDisplay(image: String, text: String) -> some View {
        VStack {
            Image(systemName: image)
            Text(text)
        }
    }
}

struct RecipeTabView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeTabView()
    }
}
