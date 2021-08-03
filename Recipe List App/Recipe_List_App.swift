//
//  Recipe_List_App.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 6/24/21.
//

import SwiftUI

@main
struct Recipe_List_App: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            RecipeTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
