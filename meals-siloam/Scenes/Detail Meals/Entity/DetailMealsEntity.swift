//
//  DetailMealsEntity.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Foundation

internal struct DetailMealsEntity: Codable {
    var meals: [DetailMeal]
}

internal struct DetailMeal: Codable, Hashable {
    var idMeal: String = ""
    var nameMeal: String = ""
    var categoryMeal: String = ""
    var area: String = ""
    var instructions: String = ""
    var mealThumb: String = ""
    var Ingredient: String = ""
    var linkYoutube: String = ""
    var uuid = UUID()
    
    static func ==(lhs: DetailMeal, rhs: DetailMeal) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
