//
//  Style.swift
//  Project
//
//  Created by Doğukan on 28.12.2021.
//

// ***** This class includes all object style. *****


import Foundation
import UIKit

class Style {
    
    let account = AccountViewController()

    func rightTopButton(_ input:UIButton) {
        if (!account.checkAccount()) {
            Style.signInButton(input)
        } else {
            Style.myAccountButton(input)
        }
    }
    
    static func textFieldArea(_ input:UITextField) {
        input.layer.borderColor = UIColor.systemGreen.cgColor
        input.layer.borderWidth = 1.0
    }
    
    static func numberLabel(_ input:UILabel!) {
        input.layer.borderColor = UIColor.black.cgColor
        input.layer.borderWidth = 1.5
    }
    
    static func accountLabelLeft(_ input:UILabel!) {
        input.layer.borderColor = UIColor.black.cgColor
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 15.0
        input.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    static func accountLabelRight(_ input:UILabel!) {
        input.layer.borderColor = UIColor.black.cgColor
        input.layer.borderWidth = 0.5
        input.layer.cornerRadius = 15.0
        input.layer.maskedCorners =  [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    static func signInButton(_ input:UIButton) {
        input.backgroundColor = UIColor.systemGreen
        input.setTitle("Sign In", for: .normal)
        input.setImage(nil, for: .normal)
        input.tintColor = UIColor.white
        input.layer.cornerRadius = 15.0
    }
    
    static func purchaseButton(_ input:UIButton) {
        input.backgroundColor = UIColor.systemGreen
        input.tintColor = UIColor.white
        input.layer.cornerRadius = 15.0
    }
    
    static func myAccountButton(_ input:UIButton) {
        input.backgroundColor = UIColor.black
        input.setTitle("", for: .normal)
        input.setImage(UIImage(systemName: "person"), for: .normal)
        input.tintColor = UIColor.white
        input.layer.cornerRadius = 15.0
    }
    
    static func signUpbutton(_ input:UIButton) {
        input.backgroundColor = UIColor.black
        input.setTitle("Sign Up", for: .normal)
        input.tintColor = UIColor.white
        input.layer.cornerRadius = 15.0
    }
    
    static func logOutbutton(_ input:UIButton) {
        input.backgroundColor = UIColor.systemRed
        input.setTitle("Sign Out", for: .normal)
        input.tintColor = UIColor.white
        input.layer.cornerRadius = 15.0
    }
    
    static func addToBag(_ input:UIButton) {
        input.backgroundColor = UIColor.systemGreen
        input.tintColor = UIColor.white
        input.layer.cornerRadius = 15.0
    }
    
    static func minusUpbutton(_ input:UIButton) {
        input.backgroundColor = UIColor.systemRed
        input.tintColor = UIColor.white
        input.layer.cornerRadius = 15.0
        input.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    static func plusUpbutton(_ input:UIButton) {
        input.backgroundColor = UIColor.systemGreen
        input.tintColor = UIColor.white
        input.layer.cornerRadius = 15.0
        input.layer.maskedCorners =  [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    static func imageMeal(_ input:UIImageView) {
        input.layer.borderWidth = 1
        input.layer.masksToBounds = false
        input.layer.borderColor = UIColor.black.cgColor
        input.layer.cornerRadius = input.frame.height/2
        input.clipsToBounds = true
    }
    
    static func imageFavList(_ input:UIImageView) {
        input.layer.borderWidth = 0.7
        input.layer.masksToBounds = false
        input.layer.borderColor = UIColor.black.cgColor
        input.layer.cornerRadius = 5.0
        input.clipsToBounds = true
    }
    
    static func viewContenier(_ input:UIView) {
        input.layer.borderColor = UIColor.systemGray.cgColor
        input.layer.borderWidth = 0.5
    }
}
