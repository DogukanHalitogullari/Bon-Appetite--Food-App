//
//  DetailViewController.swift
//  Project
//
//  Created by Doğukan on 6.01.2022.
//

import UIKit
import Firebase
import Firebase
import FirebaseAuth

class DetailViewController: UIViewController, UserDataSourceDelegate {
    
    var info = ""
    var amount = 1
    var meal: Meal?
    var isFav = false
    var preparation = ""
    var checkInBag = false
    var amountDetail: Int?
    var isBagScreen = false
    var bag = [String: String]()
    let account = AccountViewController()
    let userDataSource = UserDataSource()
    let basketDataSource = BasketDataSource()
    let favortiteDataSource = FavoriteDataSource()
    let basketViewController = BasketViewController()
    let favoriteViewController = FavoriteViewController()
    let logInPageViewController = LoginPageViewController()
    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var minesButton: UIButton!
    @IBOutlet weak var addToBag: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealPriceLabel: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var rightTopButton: UIButton! 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        styleObject() //called style of button, label etc.
        setData() //called data
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkInBag = false
        if (account.checkAccount()) { //if account opened
            if amountDetail != 0 { //basket viewcontroller send amount of item. Therefore, if item grethar than 0, this means to bag scrren opended.
                isBagScreen = true
                if let amountcheck = amountDetail {
                    amount = amountcheck
                    numberLabel.text = "\(amount)"
                }
            }
            userDataSource.delegate = self
            userDataSource.getData(userUid: Auth.auth().currentUser?.uid ?? "")
        }
    }
    
    func checkInBag(user: User, mealId: String) -> Bool { //this function check meal is or is not in bag
        if (user.basket.count != 0) {
            for i in 0...user.basket.count-1 { //check bag item into meal
                if ((user.basket[i]["mealId"]) == mealId) { //if meal is in bag, initialize this meal true. This means meal added in bag
                    return true
                }
            }
        }
        return false
    }
    
    func userDetailLoaded(user: User) {
        if (!isBagScreen) {
            addToBag.setTitle("Add To Bag", for: .normal)
            if (checkInBag(user: user, mealId: meal?.id ?? "")) { //opening the screen, check meal is or is not in bag list according to user data
                checkInBag = true
                addToBag.setTitle("Added in bag ", for: .normal)
            }
        } else {
            addToBag.setTitle("Update Bag", for: .normal)
        }
        
        if (user.favorite.contains(meal?.id ?? "")) { //opening the screen, check meal is or is not in fav list according to user data
            isFav=true
            rightTopButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    func setData() { //initialize data
        self.mealNameLabel.text = meal?.name
        self.mealPriceLabel.text = "\(meal?.price ?? "") $"
        self.mealImage.image = UIImage(named: meal?.image ?? "")
        numberLabel.text = "\(amount)"
        info = "--Ingredients--\n"
        
        for item in meal?.ingredients ?? [] { //initialeze ingredients line by line
            info = "\(info)\n*\(item)"
        }
        info = "\(info)\n\n\n--Preparation--\n"
        info = "\(info)\n\((meal?.preparation ?? ""))"
        self.textField.text = info
    }
    
    
    func styleObject() { ///initialize object style
        rightTopButton.setImage(UIImage(systemName: "heart"), for: .normal)
        Style.plusUpbutton(plusButton)
        Style.minusUpbutton(minesButton)
        Style.addToBag(addToBag)
        Style.numberLabel(numberLabel)
        Style.imageFavList(mealImage)
    }
    
    @IBAction func minus(_ sender: Any) { //amount minus button action
        if (amount > 1) {
            amount = amount - 1
            numberLabel.text = "\(amount)"
        } else {
            self.disaplayBagErrorMessage("You can add min. 1 item in bag")
        }
    }
    
    @IBAction func plus(_ sender: Any) { //amount plus button action
        if (amount < 10) {
            amount = amount + 1
            numberLabel.text = "\(amount)"
        } else {
            self.disaplayBagErrorMessage("You can add max. 10 item in bag")
        }
    }
    
    @IBAction func favButton(_ sender: Any) { //add to fav button action
        if (account.checkAccount()) { //if account opened
            if (!isFav) { //add fav method
                favortiteDataSource.addFavoriteUser(mealID: meal?.id ?? "")
                rightTopButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                isFav = true
            } else { //remove fav bmethod
                favortiteDataSource.removeFavoriteUser(mealID: meal?.id ?? "")
                rightTopButton.setImage(UIImage(systemName: "heart"), for: .normal)
                isFav = false
            }
        } else {
            self.disaplayAccountErrorMessage("You must be logged in before continuing")
        }
    }
    
    @IBAction func addToBag(_ sender: Any) { //add to bag button action
        
        if (account.checkAccount()) { //if account opened
            if (!isBagScreen) {
                if (!checkInBag) { //add to bag method
                    addToBag.setTitle("Added in bag ", for: .normal)
                    bag = ["mealId": meal?.id ?? "", "amount": "\(amount)"]
                    basketDataSource.addBasketUser(mealID: bag)
                    checkInBag = true
                } else {
                    self.disaplayBagErrorMessage("Product already added. If you wish to change the quantity or cancel the item, please visit your bag.")
                }
            } else { //if meal added in bag before, just update meal amount
                    bag = ["mealId": meal?.id ?? "", "amount": "\(amountDetail ?? 0)"]
                    basketDataSource.removeBasketUser(mealID: bag)
                    bag = ["mealId": meal?.id ?? "", "amount": "\(amount)"]
                    amountDetail = amount
                    basketDataSource.addBasketUser(mealID: bag)
            }
        } else {
            self.disaplayAccountErrorMessage("You must be logged in before continuing")
        }
        
    }
    func disaplayBagErrorMessage(_ theMessage:String) //general alert function
    {
        let alert = UIAlertController(title: "Alert", message: theMessage, preferredStyle: UIAlertController.Style.alert);
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            action in
        }
        alert.addAction(okButton);
        self.present(alert, animated: true, completion: nil)
    }
    
    func disaplayAccountErrorMessage(_ theMessage:String) //account alert function
    {
        let alert = UIAlertController(title: "Alert", message: theMessage, preferredStyle: UIAlertController.Style.alert);
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            action in
        }
        let signInButton = UIAlertAction(title: "Sign In", style: UIAlertAction.Style.default) {   //if signinbutton selected, go to signin page
            action in
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let aboutViewController = mainStoryboard.instantiateViewController(withIdentifier: "SignIn") as! SigninViewController
            self.present(aboutViewController, animated: true, completion: nil)
        }
        let signUpButton = UIAlertAction(title: "Sign Up", style: UIAlertAction.Style.default) {   //if signup button selected, go to sign up screen
            action in
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let aboutViewController = mainStoryboard.instantiateViewController(withIdentifier: "SignUp") as! SignupViewController
            self.present(aboutViewController, animated: true, completion: nil)
        }
        alert.addAction(okButton);
        alert.addAction(signInButton);
        alert.addAction(signUpButton);
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

