//
//  BasketDataSource.swift
//  Project
//
//  Created by Doğukan on 9.01.2022.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class BasketDataSource {
    
    let dataBase = Firestore.firestore()
    
    func addBasketUser(mealID: [String: String]) {
        let db = dataBase.collection("users").document(Auth.auth().currentUser?.uid ?? "") //in current user document
        db.updateData([
            "basket": FieldValue.arrayUnion([mealID]) //arrayUnion -> update data method
        ]) { err in
            if let err = err {
                print("Error updating meal in Bag list: \(err)") //print error
            } else {
                print("Meal successfully updated in Bag lisr")
            }
        }
    }
    
    func removeBasketUser(mealID: [String: String]) {
        let db = dataBase.collection("users").document(Auth.auth().currentUser?.uid ?? "") //in current user document
        db.updateData([
            "basket": FieldValue.arrayRemove([mealID]) //arrayRemove -> remove data method
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)") //print error
            } else {
                print("Document successfully updated")
            }
        }
    }
}
