//
//  Meal.swift
//  Project
//
//  Created by Doğukan on 30.12.2021.
//

import Foundation

struct Meal: Identifiable{
    let id: String
    let image: String
    let ingredients: [String]
    let name: String
    let preparation: String
    let price: String
}
