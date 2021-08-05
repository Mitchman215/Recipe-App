//
//  RecipeModel.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 6/24/21.
//

import Foundation
import UIKit
import CoreData

class RecipeModel: ObservableObject {
    
    // Reference to the managed object context
    private let managedObjectContext = PersistenceController.shared.container.viewContext
    
    @Published var categories = Set<String>()
    @Published var selectedCategory: String?
    
    init() {
        // Check if we have preloaded the data into core data
        checkLoadedData()
        
        // If categories hasn't been filled, call fillCategories
        if categories.count == 0 {
            fillCategories()
        }
    }
    
    func checkLoadedData() {
        // Check local storage for the flag
        let status = UserDefaults.standard.bool(forKey: Constants.isDataPreloaded)
        
        // If it's false, then we should parse the local json and preload into Core Data
        if !status {
            preloadLocalData()
        }
    }
    
    /// Preloads the recipe data included in the local json file into Core Data upon app initialization for the first time
    private func preloadLocalData() {
        // Parse the local JSON file
        let localRecipes = DataService.getLocalData()
        
        // Create Core Data objects from the local JSON data
        for r in localRecipes {
            // Create Core Data recipe object and set its properties
            let recipe = Recipe(context: managedObjectContext)
            recipe.category = r.category
            recipe.cookTime = r.cookTime
            recipe.directions = r.directions
            recipe.featured = r.featured
            recipe.highlights = r.highlights
            recipe.id = UUID()
            recipe.image = UIImage(named: r.image)?.jpegData(compressionQuality: 1.0)
            recipe.name = r.name
            recipe.prepTime = r.prepTime
            recipe.servings = r.servings
            recipe.summary = r.description
            recipe.totalTime = r.totalTime
            
            // Create Core Data ingredients object and set its properties
            for i in r.ingredients {
                let ingredient = Ingredient(context: managedObjectContext)
                ingredient.id = UUID()
                ingredient.name = i.name
                ingredient.unit = i.unit
                ingredient.num = i.num ?? 1
                ingredient.denom = i.denom ?? 1
                // Add ingredient to the recipe
                recipe.addToIngredients(ingredient)
            }
            
            // Add the category to the categories set
            self.categories.insert(r.category)
        }
        
        // Add "All Recipes" as a category
        self.categories.update(with: Constants.defaultListFilter)
        
        do {
            // Save into Core Data
            try managedObjectContext.save()
            
            // Set local storage flag
            UserDefaults.standard.setValue(true, forKey: Constants.isDataPreloaded)
        }
        catch {
            // Couldn't save to core data
            print(error.localizedDescription)
        }
    }
    
    /// Fetches the recipes and fills the categories set with all the categories present in the recipes
    private func fillCategories() {
        let recipesFetch = NSFetchRequest<Recipe>(entityName: "Recipe")
        do {
            let recipes = try managedObjectContext.fetch(recipesFetch)
            self.categories = Set(recipes.map { r in
                return r.category
            })
            self.categories.update(with: Constants.defaultListFilter)
        }
        catch {
            print("Could not fetch the recipes to fill the categories set")
        }
        
    }
    
    static func getPortion(ingredient:Ingredient, recipeServings:Int, targetServings:Int) -> String {
        var portion = ""
        var numerator = ingredient.num
        var denominator = ingredient.denom
        var wholePortions = 0
        
        // Get a single serving size by multiplying denom by recipe servings
        denominator *= recipeServings
        
        // Get target portion by multiplying numerator by target servings
        numerator *= targetServings
        
        // Reduce fraction by greatest common divisor
        let divisor = Rational.greatestCommonDivisor(numerator, denominator)
        numerator /= divisor
        denominator /= divisor
        
        // Get the whole portions if numerator > denom
        if numerator >= denominator {
            wholePortions = numerator / denominator
            numerator = numerator % denominator
            portion += String(wholePortions)
        }
        
        // Express the remainder as a fraction
        if numerator > 0 {
            portion += wholePortions > 0 ? " " : ""
            portion += "\(numerator)/\(denominator)"
        }
        
        if var unit = ingredient.unit {
            
            // if we need to pluralize
            if wholePortions > 1 {
                // calculate appropriate suffix
                if unit.suffix(2) == "ch" {
                    unit += "es"
                } else if unit.suffix(1) == "f" {
                    unit = String(unit.dropLast())
                    unit += "ves"
                } else {
                    unit += "s"
                }
            }
            
            
            
            portion += " "

            return portion + unit
        }
        
        return portion
    }
    
}
