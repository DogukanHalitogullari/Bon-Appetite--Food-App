//
//  BasketViewController.swift
//  Project
//
//  Created by Doğukan on 27.12.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class BasketViewController: UIViewController {

    var totalPrice = 0
    let style = Style()
    var bag:[[String: String]] = []
    let userDataSource = UserDataSource()
    let mealDataSource = MealDataSource()
    let basketDataSource = BasketDataSource()
    let account = AccountViewController()
    var bagRemovedItem = [String: String]()
    var refreshControl   = UIRefreshControl()
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var approveView: UIView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var rightTopButton: UIButton!
    @IBOutlet weak var basketTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        styleObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        totalPrice = 0
        super.viewWillAppear(animated)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        style.rightTopButton(rightTopButton) //call style of right top button accordin to account situation. This is a function and it checks firstly account open or not open in function body
        if (account.checkAccount()) {
            userDataSource.delegate = self
            if let personelid =  Auth.auth().currentUser?.uid {
                userDataSource.getData(userUid: personelid) //get current user data
            }
        }
        self.priceLabel.text = "\(totalPrice) $"
    }
    
    func styleObject() {
        Style.viewContenier(approveView)
        Style.purchaseButton(proceedButton)
    }
    
    @objc func refresh(_ sender: AnyObject)
    {
        self.basketTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
   
    
    @IBAction func rightTopButton(_ sender: Any) {
        if (account.checkAccount()) {
            let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AccountVC") as? AccountViewController //next Account scrren
            self.navigationController?.pushViewController(screen!, animated: true)
        } else {
            let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogIn") as? LoginPageViewController //next Login screen
            self.navigationController?.pushViewController(screen!, animated: true)
        }
    }
    
    
    @IBAction func proceedButton(_ sender: Any) { //proceed checkout button function // this function delete all item in table
        if (bag.count != 0) {
            for item in bag {
                basketDataSource.removeBasketUser(mealID: item)
            }
            totalPrice = 0
            self.priceLabel.text = "\(totalPrice) $"
            let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ConfirmCv") as?   ConfirmationViewController //directedd confirmation message page
            self.navigationController?.pushViewController(screen!, animated: true)
        } else {
            disaplayErrorMessage("Your bag is empty.")
        }
        
    }
    
    func disaplayErrorMessage(_ theMessage:String) // error message function
    {
        //Display alert message with confirmation.
        let myAlert = UIAlertController(title: "Alert", message: theMessage, preferredStyle: UIAlertController.Style.alert);
        let OkAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            action in
        }
        myAlert.addAction(OkAction);
        self.present(myAlert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //let cell = sender as! BasketTableViewCell
            if let indexPath = self.basketTableView.indexPath(for: sender as! BasketTableViewCell) {
                let meal = mealDataSource.getMealForId(id: bag[indexPath.row]["mealId"] ?? "")
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.amountDetail = Int(self.bag[indexPath.row]["amount"] ?? "")
                detailViewController.meal = meal
            }
    }
}

extension BasketViewController: UITableViewDataSource, UserDataSourceDelegate, MealDataSourceDelegate {
 
    func userDetailLoaded(user: User) {
        self.bag = user.basket
        mealDataSource.delegate = self
        mealDataSource.get()
    }
    
    func mealListLoaded() {
        basketTableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (account.checkAccount()) {
            return (self.bag.count)
        }
        return 0 //if account not open, close tableview
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //initialize meal on table
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketCell", for: indexPath) as! BasketTableViewCell
        let meal = mealDataSource.getMealForId(id: bag[indexPath.row]["mealId"] ?? "")
        Style.imageMeal(cell.mealImage)
        cell.mealNameLabel.text = meal.name
        cell.amountLabel.text = "\(bag[indexPath.row]["amount"] ?? "") x"
        cell.mealPriceLabel.text = "\(meal.price) $"
        cell.mealImage.image = UIImage(named: meal.image)
        totalPrice = totalPrice + (Int(meal.price)! * Int(bag[indexPath.row]["amount"] ?? "")!)
        print(bag[indexPath.row]["amount"] ?? "")
        print(totalPrice)
        self.priceLabel.text = "\(totalPrice) $"
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { //delete meal in bag screen
        if editingStyle == .delete {
            tableView.beginUpdates()
            bagRemovedItem = bag[indexPath.row]
            let meal = mealDataSource.getMealForId(id: bag[indexPath.row]["mealId"] ?? "")
            totalPrice = totalPrice - (Int(meal.price)! * Int(bag[indexPath.row]["amount"] ?? "")!)
            self.priceLabel.text = "\(totalPrice) $"
            bag.remove(at: indexPath.row)
            basketDataSource.removeBasketUser(mealID: bagRemovedItem)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
          
        }
    }
}

