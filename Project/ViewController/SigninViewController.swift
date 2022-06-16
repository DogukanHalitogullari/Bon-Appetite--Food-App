//
//  SiginViewController.swift
//  Project
//
//  Created by Doğukan on 28.12.2021.
//

import UIKit
import FirebaseAnalytics
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SigninViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Sign In"
        styleObject()
       
    }
    
    func styleObject() {
        Style.textFieldArea(email) //adjust text field area
        Style.textFieldArea(password)
        Style.signInButton(signInButton)
        password.isSecureTextEntry = true
        errorLabel.alpha = 0 // error label not visible
    }
    
    
    @IBAction func signInPress(_ sender: Any) {
        let email = email.text!.trimmingCharacters(in: .whitespacesAndNewlines) //initialize email
        let password = password.text!.trimmingCharacters(in: .whitespacesAndNewlines) //initialize password
    
        Auth.auth().signIn(withEmail: email, password: password) { (result, errorSignIn) in //signInFunction
            if errorSignIn != nil { //initialize error
                self.errorLabel.text = errorSignIn?.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                self.errorLabel.text = "Account Opened. You will be redirected to the home page in 3 seconds."
                self.errorLabel.textColor = UIColor.systemGreen
                self.errorLabel.alpha = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { //wait 3 seconds
                    self.navigationController?.popToRootViewController(animated: true)
                    self.dismiss(animated: true, completion: nil);
                    
                 }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
