//
//  RecipeHighlights.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 7/1/21.
//

import SwiftUI

struct RecipeHighlights: View {
    
    var allHighlights = ""
    
    var body: some View {
        Text(allHighlights)
    }
    
    init(highlights:[String]) {
        // loop through the highlights and build the string
        for index in 0..<highlights.count {
            // if this is the last item, don't add a comma
            if index == highlights.count - 1 {
                allHighlights += highlights[index]
            } else {
                allHighlights += highlights[index] + ", "
            }
        }
    }
}

struct RecipeHighlights_Previews: PreviewProvider {
    static var previews: some View {
        RecipeHighlights(highlights: ["test", "test2"])
    }
}
