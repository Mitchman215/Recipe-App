//
//  DataService.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 6/24/21.
//

import Foundation

class DataService {
    
    // Parse local json file
    static func getLocalData() -> [RecipeJSON] {

        // Get a url path to json
        let pathString = Bundle.main.path(forResource: "recipes", ofType: "json")

        //check that pathString is not nil, otherwise
        guard pathString != nil else {
            return [RecipeJSON]()
        }
        // Create a url object
        let url = URL(fileURLWithPath: pathString!)

        // Create a data object
        do {
            let data = try Data(contentsOf: url)

            let decoder = JSONDecoder()

            do {

                let recipeData = try decoder.decode([RecipeJSON].self, from: data)

                // Creates unique ids
                for r in recipeData {
                    r.id = UUID()

                    // Add unique ids to recipe ingredients
                    for i in r.ingredients {
                        i.id = UUID()
                    }
                }

                return recipeData
            } catch {
                // error with parsing json
                print(error)
            }

        }
        catch {
            print(error)
        }

        return [RecipeJSON]()
    }
    
}
