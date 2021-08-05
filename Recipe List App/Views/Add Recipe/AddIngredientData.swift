//
//  AddIngredientData.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 8/5/21.
//

import SwiftUI

struct AddIngredientData: View {
    
    @Binding var ingredients: [IngredientJSON]
    
    @State private var name = ""
    @State private var num = ""
    @State private var denom = ""
    @State private var unit = ""
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            Text("Ingredients: ")
                .bold()
                .padding(.top, 5)
            
            HStack {
                TextField("Sugar", text: $name)
                
                TextField("1", text: $num)
                    .frame(width: 25)
                
                Text("/")
                
                TextField("2", text: $denom)
                    .frame(width: 25)
                
                TextField("cups", text: $unit)
                
                Button("Add") {
                    
                    // Make sure that the fields are populated
                    let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    let cleanedNum = num.trimmingCharacters(in: .whitespacesAndNewlines)
                    let cleanedDenom = denom.trimmingCharacters(in: .whitespacesAndNewlines)
                    let cleanedUnit = unit.trimmingCharacters(in: .whitespacesAndNewlines)
                    if cleanedName == "" || cleanedNum == "" || cleanedDenom == "0" || cleanedUnit == "" {
                        return
                    }
                    
                    // Create an IngredientJSON object and set it's properties
                    let i = IngredientJSON()
                    i.id = UUID()
                    i.name = cleanedName
                    i.num = Int(cleanedNum) ?? 1
                    i.denom = Int(cleanedDenom) ?? 1
                    i.unit = cleanedUnit
                    
                    // Add new ingredient to the list
                    ingredients.append(i)
                    
                    // Clear text fields
                    name = ""
                    num = ""
                    denom = ""
                    unit = ""
                }
            }
            
            ForEach(ingredients) { i in
                Text("\(i.name), \(i.num ?? 1)/\(i.denom ?? 1) \(i.unit ?? "")")
            }
            
        }
    }
}
