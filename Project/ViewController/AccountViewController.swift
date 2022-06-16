//
//  AccountViewController.swift
//  Project
//
//  Created by Doğukan on 27.12.2021.
//

import UIKit
import Firebase
import Firebase
import FirebaseAuth


class AccountViewController: UIViewController {

    let userDataSource = UserDataSource()
    
    @IBOutlet weak var logOut: UIButton!
    @IBOutlet weak var nameLeft: UILabel!
    @IBOutlet weak var phoneLeft: UILabel!
    @IBOutlet weak var emailLeft: UILabel!
    @IBOutlet weak var nameRight: UILabel!
    @IBOutlet weak var phoneRight: UILabel!
    @IBOutlet weak var emailRight: UILabel!
    @IBOutlet weak var surnameLeft: UILabel!
    @IBOutlet weak var surnameRight: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (!checkAccount()) {
            isNotAccount()
        } else {
            isAccount()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "My Account"
        userDataSource.delegate = self
        styleObject()
    }
    
    func checkAccount() -> Bool {
        if Auth.auth().currentUser?.uid == nil {
            return false
        }
        return true
    }
    
    func styleObject() {
        Style.accountLabelLeft(nameLeft)
        Style.accountLabelLeft(surnameLeft)
        Style.accountLabelLeft(emailLeft)
        Style.accountLabelLeft(phoneLeft)
        Style.accountLabelRight(nameRight)
        Style.accountLabelRight(surnameRight)
        Style.accountLabelRight(emailRight)
        Style.accountLabelRight(phoneRight)
        Style.logOutbutton(logOut)
    }
    
    func isAccount() {
        nameRight.alpha = 1
        surnameRight.alpha = 1
        phoneRight.alpha = 1
        emailRight.alpha = 1
        nameLeft.alpha = 1
        surnameLeft.alpha = 1
        emailLeft.alpha = 1
        phoneLeft.alpha = 1
        logOut.alpha = 1
        userDataSource.getData(userUid: Auth.auth().currentUser?.uid ?? "")
    }
    
    func isNotAccount() {
        nameRight.alpha = 0
        surnameRight.alpha = 0
        phoneRight.alpha = 0
        emailRight.alpha = 0
        nameLeft.alpha = 0
        surnameLeft.alpha = 0
        emailLeft.alpha = 0
        phoneLeft.alpha = 0
        logOut.alpha = 0
    }
    
    func transitionToLogInScreen() {
        let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogIn") as? LoginPageViewController
        self.navigationController?.pushViewController(screen!, animated: true)
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        do { try Auth.auth().signOut() }
            catch { print("already logged out") }
        self.navigationController?.popViewController(animated: true)
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

extension AccountViewController: UserDataSourceDelegate {
    func userDetailLoaded(user: User) {
        self.nameRight.text = " \(user.firstName)"
        self.surnameRight.text = " \(user.lastName)"
        self.phoneRight.text = " \(user.phone)"
        self.emailRight.text = " \(user.email)"
    }
}
