//
//  AddRecipeView.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 8/5/21.
//

import SwiftUI

struct AddRecipeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // Tab selection
    @Binding var selection: Int
    
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
    
    // Ingredient data
    @State private var ingredients = [IngredientJSON]()
    
    // Recipe image
    @State private var recipeImage: UIImage?
    
    // Image picker
    @State private var isShowingImagePicker = false
    @State private var selectedImageSource = UIImagePickerController.SourceType.photoLibrary
    @State private var placeHolderImage = Image("noImageAvailable")
    
    var body: some View {
        
        VStack {
            // HStack with form controls
            HStack {
                Button("Clear") {
                    // Clear the form
                    clear()
                }
                
                Spacer()
                
                Button("Add") {
                    // Add the recipe to core data
                    addRecipe()
                    
                    // Clear the form
                    clear()
                    
                    // Navigate to the list
                    selection = Constants.listTab
                }
            }
            
            ScrollView (showsIndicators: false) {
                VStack (alignment: .leading) {
                    
                    // Recipe image
                    placeHolderImage
                        .resizable()
                        .scaledToFit()
                    
                    HStack {
                        Button("Photo Library") {
                            selectedImageSource = .photoLibrary
                            isShowingImagePicker = true
                        }
                        Text(" | ")
                        Button("Camera") {
                            selectedImageSource = .camera
                            isShowingImagePicker = true
                        }
                    }
                    .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                        ImagePicker(selectedSource: selectedImageSource, recipeImage: $recipeImage)
                    }
                    
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
                    
                    // Place to add ingredient data
                    AddIngredientData(ingredients: $ingredients)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func loadImage() {
        // Check if an image was selected from the library
        if recipeImage != nil {
            // Set it as the placeholder image
            placeHolderImage = Image(uiImage: recipeImage!)
        }
    }
    
    private func propertyField(fieldName: String, example: String, textBind: Binding<String>) -> some View {
        HStack {
            Text(fieldName + ": ")
                .bold()
            TextField(example, text: textBind)
        }
    }
    
    /// Clears all the form fields
    private func clear() {
        name = ""
        category = ""
        summary = ""
        prepTime = ""
        cookTime = ""
        totalTime = ""
        servings = ""
    
        highlights = [String]()
        directions = [String]()
        
        ingredients = [IngredientJSON]()
        
        placeHolderImage = Image("noImageAvailable")
        recipeImage = nil
    }
    
    /// Add the recipe into core data
    private func addRecipe() {
        let recipe = Recipe(context: viewContext)
        recipe.id = UUID()
        recipe.name = name
        recipe.category = category
        recipe.cookTime = cookTime
        recipe.prepTime = prepTime
        recipe.totalTime = totalTime
        recipe.servings = Int(servings) ?? 1
        recipe.directions = directions
        recipe.highlights = highlights
        recipe.image = recipeImage?.pngData()
        
        // Set ingredients
        for i in ingredients {
            let ingredient = Ingredient(context: viewContext)
            ingredient.id = UUID()
            ingredient.name = i.name
            ingredient.unit = i.unit
            ingredient.num = i.num ?? 1
            ingredient.denom = i.denom ?? 1
            // Add the ingredient to the recipe
            recipe.addToIngredients(ingredient)
        }
        
        
        do {
            // save recipe to core data
            try viewContext.save()
            
            // Switch the view to list view
        }
        catch {
            // Couldn't save the recipe
            print(error.localizedDescription)
        }
    }
}
