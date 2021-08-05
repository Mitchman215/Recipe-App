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
    
    @State private var filterBy = ""
    
    /// The recipes filtered by a search term and/ or a selected category
    private var filteredRecipes: [Recipe] {
        let filterByWithoutSpaces = filterBy.trimmingCharacters(in: .whitespacesAndNewlines)
        let filterByEmpty = (filterByWithoutSpaces == "")
        let noSelectedCategory = (model.selectedCategory == Constants.defaultListFilter)
        
        if filterByEmpty && noSelectedCategory {
            // No filter text or category, so return all recipes
            return Array(recipes)
        }
        else {
            // Filter by the searched term and selected category
            return recipes.filter { (r) -> Bool in
                return (filterByEmpty || r.name.localizedCaseInsensitiveContains(filterByWithoutSpaces)) &&
                    (noSelectedCategory || r.category == model.selectedCategory)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                
                HStack {
                    // Title
                    Text(model.selectedCategory)
                        .bold()
                        .font(Font.custom("Avenir Heavy", size: 24))
                    
                    Spacer()
                    
                    // Button to clear categories
                    if model.selectedCategory != Constants.defaultListFilter {
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
                
                SearchBarView(filterBy: $filterBy)
                    .padding([.trailing, .bottom])
                
                ScrollView {
                    LazyVStack (alignment: .leading) {
                        ForEach(filteredRecipes) { r in
                            
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
            .navigationBarHidden(true)
            .padding(.leading)
            .onTapGesture {
                // Resign first responder
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
            .environmentObject(RecipeModel())
    }
}
