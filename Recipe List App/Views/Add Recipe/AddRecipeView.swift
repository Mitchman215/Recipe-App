//
//  AddRecipeView.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 8/5/21.
//

import SwiftUI

struct AddRecipeView: View {
    
    // Properties for recipe meta data
    @State private var name = ""
    @State private var category = ""
    @State private var summary = ""
    @State private var prepTime = ""
    @State private var cookTime = ""
    @State private var totalTime = ""
    @State private var servings = ""
    
    // List type recipe meta data
    @State private var highlights = [String]()
    @State private var directions = [String]()
    
    
    var body: some View {
        
        VStack {
            // HStack with form controls
            HStack {
                Button("Clear") {
                    // Clear the form
                }
                
                Spacer()
                
                Button("Add") {
                    // Add the recipe to core data
                    
                    // Clear the form
                }
            }
            
            ScrollView (showsIndicators: false) {
                VStack (alignment: .leading) {
                    
                    // Fields for the user to enter in each property of the recipe
                    Group {
                        propertyField(fieldName: "Name", example: "Tuna Casserrole", textBind: $name)
                        propertyField(fieldName: "Category", example: "American", textBind: $category)
                        propertyField(fieldName: "Summary", example: "A delicious meal for the whole family", textBind: $summary)
                        propertyField(fieldName: "Prep time", example: "1 hour", textBind: $prepTime)
                        propertyField(fieldName: "Cooking time", example: "2 hours", textBind: $cookTime)
                        propertyField(fieldName: "Total time", example: "3 hours", textBind: $totalTime)
                        propertyField(fieldName: "Servings", example: "6", textBind: $servings)
                    }
                    
                    // Place to add list data to the recipe
                    AddListData(fieldName: "Highlights", example: "Savory", listBind: $highlights)
                    AddListData(fieldName: "Directions", example: "Preheat oven to 425°F.", listBind: $directions)
                    
                    
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func propertyField(fieldName: String, example: String, textBind: Binding<String>) -> some View {
        HStack {
            Text(fieldName + ": ")
            TextField(example, text: textBind)
        }
    }
    
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}
