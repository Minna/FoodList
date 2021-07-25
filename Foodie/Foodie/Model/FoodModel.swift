//
//  FoodModel.swift
//  Foodie
//
//  Created by Minna on 23/07/21.
//

import Foundation
import Foundation

// MARK: - Welcome
struct FoodModel: Codable {
    let meals: [Meal]?
    
}

// MARK: - Meal
// MARK: - Meal
struct Meal : Codable{
    let idMeal, strMeal: String?
    let strDrinkAlternate: String?
    let strCategory, strArea, strInstructions: String?
    let strMealThumb: String?
    let strTags: String?
    let strYoutube: String?
    let strMeasure7, strMeasure8, strMeasure9, strMeasure10: String?
    let strMeasure11, strMeasure12, strMeasure13, strMeasure14: String?
    let strMeasure15, strMeasure16, strMeasure17, strMeasure18: String?
    let strMeasure19, strMeasure20: String?
    let strSource: String?
    let strImageSource, strCreativeCommonsConfirmed : String?
    let    dateModified: String?
}
