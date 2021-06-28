//
//  RecipeModel.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 6/24/21.
//

import Foundation

class RecipeModel: ObservableObject {
    
    @Published var recipes = [Recipe]()
    
    init() {
        
        // Create an instance of data service and get the data
        self.recipes = DataService.getLocalData()
    }
    
}
