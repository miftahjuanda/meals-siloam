//
//  FindMealsEntity.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Foundation

internal struct FindMealsEntity: Codable {
    var meals: [Meal]
}

internal struct Meal: Codable, Hashable {
    let idMeal: String
    let nameMeal: String
    let area: String
    let mealThumb: String
    var uuid = UUID()
    
    static func ==(lhs: Meal, rhs: Meal) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
