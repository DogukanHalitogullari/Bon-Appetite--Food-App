//
//  MealDataSource.swift
//  Project
//
//  Created by Doğukan on 30.12.2021.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore


class MealDataSource {
    
    private var meal: [Meal] = []
    let database = Firestore.firestore()
    var delegate: MealDataSourceDelegate?
    
    func getNumberOfMeal() -> Int { //this function return meal number in list
         return meal.count
     }
     
     func getMealForIndex(index: Int) -> Meal { //this funciton return meal index number in Meal array
         let realIndex = index % meal.count
         return meal[realIndex]
     }
    
    func getMealForId(id: String) -> Meal{ //get meal according to meal Id
        var index = 0
        for i in 0..<meal.count {
            if (meal[i].id == id) {
                index = i
            }
        }
        return getMealForIndex(index: index)
    }
    
      func get() { //get meal from firebase -> firestore fieldd
           database.collection("meals").addSnapshotListener { querySnapshot, err in //select collection
                    if let error = err {
                        print(error)  //error label
                    } else {
                        for d in querySnapshot?.documents ?? [] { //visit all meal
                            self.meal.append(Meal(id: d.documentID, //append meal in swift meal array
                                              image: d["image"] as? String ?? "",
                                              ingredients: d["ingredients"] as? [String] ?? [],
                                              name: d["name"] as? String ?? "",
                                              preparation: d["preparation"] as? String ?? "",
                                              price: d["price"] as? String ?? ""))
                        }
                        DispatchQueue.main.async {
                            self.delegate?.mealListLoaded() //call delegate -> meallistloaded
                        }
                    }
                }
        }
}
