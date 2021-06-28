//
//  Ingredient.swift
//  Recipe List App
//
//  Created by Mitchell Salomon on 6/28/21.
//

import Foundation

class Ingredient: Identifiable, Decodable {
    
    var id:UUID?
    var name:String
    var num:Int?
    var denom:Int?
    var unit:String?
    
}
