//
//  ContentView.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 6/24/21.
//

import SwiftUI

struct RecipeListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var model:RecipeModel
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    private var recipes: FetchedResults<Recipe>
    
    private var titleText: String {
        if model.selectedCategory == nil || model.selectedCategory == Constants.defaultListFilter {
            return "All Recipes"
        }
        else {
            return model.selectedCategory!
        }
    }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                
                HStack {
                    // Title
                    Text(titleText)
                        .bold()
                        .font(Font.custom("Avenir Heavy", size: 24))
                    
                    Spacer()
                    
                    // Button to clear categories
                    if model.selectedCategory != nil && model.selectedCategory != Constants.defaultListFilter {
                        Button(action: {
                            model.selectedCategory = Constants.defaultListFilter
                        }, label: {
                            Text("Clear selected category")
                                .font(Font.custom("Avenir Heavy", size: 16))
                        })
                    }
                }
                .padding(.top, 40)
                .padding(.trailing)
                
                ScrollView {
                    LazyVStack (alignment: .leading) {
                        ForEach(recipes) { r in
                            
                            if model.selectedCategory == nil ||
                                model.selectedCategory == Constants.defaultListFilter ||
                                model.selectedCategory != nil && r.category == model.selectedCategory {
                                
                                NavigationLink(
                                    destination: RecipeDetailView(recipe: r),
                                    label: {
                                        
                                        // MARK: Row item
                                        HStack(spacing: 20.0) {
                                            let image = UIImage(data: r.image ?? Data()) ?? UIImage()
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50, alignment: .center)
                                                .clipped()
                                                .cornerRadius(5)
                                            
                                            VStack (alignment: .leading) {
                                                Text(r.name)
                                                    .foregroundColor(.black)
                                                    .font(Font.custom("Avenir Heavy", size: 16))
                                                RecipeHighlights(highlights: r.highlights)
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    })
                            }
                        }
                    }
                    
                }
            }
            .navigationBarHidden(true)
            .padding(.leading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
            .environmentObject(RecipeModel())
    }
}
