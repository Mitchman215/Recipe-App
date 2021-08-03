//
//  Recipe.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 6/24/21.
//

import Foundation

class RecipeJSON: Identifiable, Decodable {
    
    var id:UUID?
    var name:String
    var category:String
    var featured:Bool
    var image:String
    var description:String
    var prepTime:String
    var cookTime:String
    var totalTime:String
    var servings:Int
    var highlights:[String]
    var ingredients:[IngredientJSON]
    var directions:[String]
    
}
