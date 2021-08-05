//
//  AddListData.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 8/5/21.
//

import SwiftUI

struct AddListData: View {
    
    var fieldName: String
    var example: String
    @Binding var listBind: [String]
    
    @State private var item = ""
    
    var body: some View {
        
        VStack (alignment: .leading) {
            HStack {
                Text("\(fieldName): ")
                    .bold()
                
                TextField(example, text: $item)
                
                Button("Add") {
                    // Add the item to the list
                    if item.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                        listBind.append(item.trimmingCharacters(in: .whitespacesAndNewlines))
                        item = ""
                    }
                }
            }
            
            // List out the items added so far
            ForEach(listBind, id: \.self) { element in
                Text(element)
            }
        }
        
    }
}
