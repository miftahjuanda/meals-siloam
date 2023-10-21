//
//  FindMealsResponse.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Foundation

internal struct FindMealsResponse: Codable {
    let meals: [FindMeal]?
}

// MARK: - Meal
internal struct FindMeal: Codable {
    let idMeal, strMeal, strDrinkAlternate, strCategory: String?
    let strArea, strInstructions: String?
    let strMealThumb: String?
    let strTags: String?
    let strYoutube: String?
    let strIngredient1, strIngredient2, strIngredient3, strIngredient4: String?
    let strIngredient5, strIngredient6, strIngredient7, strIngredient8: String?
    let strIngredient9, strIngredient10, strIngredient11, strIngredient12: String?
    let strIngredient13, strIngredient14, strIngredient15, strIngredient16: String?
    let strIngredient17, strIngredient18, strIngredient19, strIngredient20: String?
    let strMeasure1, strMeasure2, strMeasure3, strMeasure4: String?
    let strMeasure5, strMeasure6, strMeasure7, strMeasure8: String?
    let strMeasure9, strMeasure10, strMeasure11, strMeasure12: String?
    let strMeasure13, strMeasure14, strMeasure15, strMeasure16: String?
    let strMeasure17, strMeasure18, strMeasure19, strMeasure20: String?
}

extension FindMealsResponse {
    func toDomain() -> FindMealsEntity {
        let meals = self.meals?.map { res in
            return Meal(idMeal: res.idMeal ?? "0",
                        nameMeal: res.strMeal ?? "-",
                        categoryMeal: res.strCategory ?? "-",
                        area: res.strArea ?? "-",
                        instructions: res.strInstructions ?? "-",
                        mealThumb: res.strMealThumb ?? "-",
                        Ingredient: ingredientAndMeasure(ingredient: res.strIngredient1 ?? "-",
                                                         measure: res.strMeasure1 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient2 ?? "-",
                                             measure: res.strMeasure2 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient3 ?? "-",
                                             measure: res.strMeasure3 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient4 ?? "-",
                                             measure: res.strMeasure4 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient5 ?? "-",
                                             measure: res.strMeasure5 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient6 ?? "-",
                                             measure: res.strMeasure6 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient7 ?? "-",
                                             measure: res.strMeasure7 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient8 ?? "-",
                                             measure: res.strMeasure8 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient9 ?? "-",
                                             measure: res.strMeasure9 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient10 ?? "-",
                                             measure: res.strMeasure10 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient11 ?? "-",
                                             measure: res.strMeasure11 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient12 ?? "-",
                                             measure: res.strMeasure12 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient13 ?? "-",
                                             measure: res.strMeasure13 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient14 ?? "-",
                                             measure: res.strMeasure14 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient15 ?? "-",
                                             measure: res.strMeasure15 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient16 ?? "-",
                                             measure: res.strMeasure16 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient17 ?? "-",
                                             measure: res.strMeasure17 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient18 ?? "-",
                                             measure: res.strMeasure18 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient19 ?? "-",
                                             measure: res.strMeasure19 ?? "-") +
                        ingredientAndMeasure(ingredient: res.strIngredient20 ?? "-",
                                             measure: res.strMeasure20 ?? "-"),
                        linkYoutube: res.strYoutube ?? "-")
        } ?? []
        return FindMealsEntity(meals: meals)
    }
}

//fileprivate func ingredientAndMeasure(ingredient: String?, measure: String?) -> String {
//    guard let ingredient = ingredient, let measure = measure else { return "" }
//    if ingredient.trimmingCharacters(in: .whitespaces).isEmpty && measure.trimmingCharacters(in: .whitespaces).isEmpty {
//        return ""
//    } else {
//        return "\(ingredient) - \(measure), "
//    }
//}
