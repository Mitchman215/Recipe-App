//
//  RecipeCategoryView.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 7/23/21.
//

import SwiftUI

struct RecipeCategoryView: View {
    
    @EnvironmentObject var model: RecipeModel
    @Binding var selectedTab: Int
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            Text("Categories")
                .bold()
                .padding(.top, 40)
                .font(Font.custom("Avenir Heavy", size: 24))
            
            GeometryReader { geo in
                
                ScrollView (showsIndicators: false) {
                    
                    LazyVGrid (columns: [GridItem(.flexible(), spacing: 20, alignment: .top),
                                         GridItem(.flexible(), spacing: 20, alignment: .top)],
                               alignment: .center, spacing: 20) {
                        
                        ForEach (Array(model.categories), id: \.self) { category in
                            
                            Button(action: {
                                // Switch tab to list view
                                selectedTab = Constants.listTab
                                // Set the selected category
                                model.selectedCategory = category
                            }, label: {
                                VStack {
                                    Image(category.lowercased())
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (geo.size.width - 20) / 2, height: (geo.size.width - 20) / 2)
                                        .cornerRadius(10)
                                        .clipped()
                                    Text(category)
                                        .foregroundColor(.black)
                                }
                            })
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .padding(.horizontal)
        
    }
}
