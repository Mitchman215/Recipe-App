//
//  DataService.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 6/24/21.
//

import Foundation

class DataService {
    
    static func getLocalData() -> [Recipe] {
        // Parse local json file
        
        // Get a url path to json
        let pathString = Bundle.main.path(forResource: "recipes", ofType: "json")
        
        //check that pathString is not nil, otherwise
        guard pathString != nil else {
            return [Recipe]()
        }
        // Create a url object
        let url = URL(fileURLWithPath: pathString!)
        
        // Create a data object
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            do {
                let recipeData = try decoder.decode([Recipe].self, from: data)
                for r in recipeData {
                    r.id = UUID()
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
        
        return [Recipe]()
    }
    
}
