//
//  LoginPageViewController.swift
//  Project
//
//  Created by Doğukan on 28.12.2021.
//

import UIKit

class LoginPageViewController: UIViewController {

    let account = AccountViewController()
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var signin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Log In"
        styleObject()
    }

    func styleObject() {
        Style.signInButton(signin)
        Style.signUpbutton(signUp)
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


