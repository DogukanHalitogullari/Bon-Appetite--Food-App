//
//  FavoriteDataSource.swift
//  Project
//
//  Created by Doğukan on 8.01.2022.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class FavoriteDataSource {
    
    let dataBase = Firestore.firestore()

    func addFavoriteUser(mealID: String) {
        let db = dataBase.collection("users").document(Auth.auth().currentUser?.uid ?? "") //in current user document
        db.updateData([
            "favList": FieldValue.arrayUnion([mealID]) //arrayUnion -> update data method
        ]) { err in
            if let err = err {
               print("Error updating meal in Favorite list: \(err)") //print error
            } else {
                print("Meal successfully updated in in Favorite list")
            }
        }
    }
    
    func removeFavoriteUser(mealID: String) {
        let db = dataBase.collection("users").document(Auth.auth().currentUser?.uid ?? "") //in current user document
        db.updateData([
            "favList": FieldValue.arrayRemove([mealID]) //arrayRemove -> remove data method
        ]) { err in
            if let err = err {
                print("Error updating meal in Favorite list: \(err)") //print error
            } else {
                print("Meal successfully updated in in Favorite list")
            }
        }
    }
}
