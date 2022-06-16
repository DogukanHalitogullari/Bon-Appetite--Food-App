//
//  SignupViewController.swift
//  Project
//
//  Created by Doğukan on 28.12.2021.
//

import UIKit
import FirebaseAnalytics
import Firebase
import FirebaseAuth
import FirebaseFirestore


class SignupViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var phone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Sign Up"
        styleObject() //called object style
    }
    
    func styleObject() {
        password.isSecureTextEntry = true
        Style.textFieldArea(firstName) //adjust text field area
        Style.textFieldArea(lastName)
        Style.textFieldArea(email)
        Style.textFieldArea(password)
        Style.textFieldArea(phone)
        Style.signUpbutton(signUpButton)
        errorLabel.alpha = 0 // error label not visible
    }
    
    func checkFields() -> String? {
        // if areas null, return error message
        if (phone.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            return "Make sure that all the fields are filled." // error message
        }
    
        if validPassword(password.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == false { //check validate password
            return "Make sure that your password should include at least 8 characters, a special character($@$#!%*?&.), english character and a number." // error mesage
        }
        return nil
    }
    
    func validPassword(_ password : String) -> Bool { //password style
        return NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&.])[A-Za-z\\d$@$#!%*?&.]{8,}").evaluate(with: password)
    }
    

    @IBAction func SignUpPress(_ sender: Any) { //sign up methode
        
        let errorFields = checkFields() //called error
        
        if errorFields != nil { // if conditions are not valid, check this function
            self.disaplayErrorMessage(errorFields!)
        } else {
            let name = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines) //initialize name
            let surname = lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines) //initialize surname
            let email = email.text!.trimmingCharacters(in: .whitespacesAndNewlines) //initialize email
            let password = password.text!.trimmingCharacters(in: .whitespacesAndNewlines) //initialize password
            let phone = phone.text!.trimmingCharacters(in: .whitespacesAndNewlines) //initialize phone
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, errorLoginImformation) in //register user information
            
                if errorLoginImformation != nil { //if user couldn't be created, this method work
                    self.disaplayErrorMessage("Account couldn't be created.")
                } else {
                    let dataBase = Firestore.firestore() //initialize database
                    dataBase.collection("users").document(result!.user.uid ).setData(["firstName":name, "lastName":surname, "email":email, "phone":phone, "uid": result!.user.uid, "favList":[], "basket":[] ]) { (errorDataBase) in
                        if errorDataBase != nil {
                            self.disaplayErrorMessage("Data couldn't be saved.")
                        } else { // Account created
                            self.errorLabel.text = "Registration Successful. Account Opened. You will be redirected to the home page in 3 seconds."
                            self.errorLabel.textColor = UIColor.systemGreen
                            self.errorLabel.alpha = 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                self.navigationController?.popToRootViewController(animated: true) //call any function
                                self.dismiss(animated: true, completion: nil);
                             }
                        }
                    }
                }
            }
        }
    }
    
    func disaplayErrorMessage(_ theMessage:String) //error label function 
    {
        let alert = UIAlertController(title: "Alert", message: theMessage, preferredStyle: UIAlertController.Style.alert);
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            action in
        }
        alert.addAction(okButton);
        self.present(alert, animated: true, completion: nil)
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
