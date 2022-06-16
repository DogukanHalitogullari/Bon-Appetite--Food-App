//
//  UserDataSource.swift
//  Project
//
//  Created by Doğukan on 7.01.2022.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore


class UserDataSource{
    
    let dataBase = Firestore.firestore()
    var delegate: UserDataSourceDelegate?
    
    func getData(userUid: String) {//get user information from firebase -> firestore fieldd
         let db = dataBase.collection("users").document(userUid) //input userUid
         db.getDocument { (document, error) in
             guard error == nil else {
                 print("error", error ?? "") //print error
                 return
             }

             if let document = document, document.exists { //if not error
                 let data = document.data()
                 if let data = data {
                     let user = (User(email: data["email"] as? String ?? "",
                                      firstName: data["firstName"] as? String ?? "",
                                      lastName: data["lastName"] as? String ?? "",
                                      phone: data["phone"] as? String ?? "",
                                      basket: data["basket"] as? [[String : String]] ?? [],
                                      favorite: data["favList"] as? [String] ?? [])) //initialize user information
                     
                     self.delegate?.userDetailLoaded(user: user) //call delegate -> userdetailloaded
                 }
            }
        }
    }
}


