//
//  MainViewController.swift
//  Project
//
//  Created by Doğukan on 27.12.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

class MainViewController: UIViewController {
    
    let style = Style()
    private var service: MealDataSource?
    let mealDataSource = MealDataSource()
    let account = AccountViewController()
    
    @IBOutlet weak var rightTopButton: UIButton!
    @IBOutlet weak var mainTableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        style.rightTopButton(rightTopButton) //call style of right top button accordin to account situation. This is a function and it checks firstly account open or not open in function body
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mealDataSource.get()
        mealDataSource.delegate = self
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! MealTableViewCell
        if let indexPath = self.mainTableView.indexPath(for: cell) {
            let meal = mealDataSource.getMealForIndex(index: indexPath.row)
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.amountDetail = 0
            detailViewController.meal = meal
        }
    }
}

extension MainViewController: MealDataSourceDelegate {
    func mealListLoaded() {
        mainTableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealDataSource.getNumberOfMeal()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //initialize meal on table
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealTableViewCell
        let meal = mealDataSource.getMealForIndex(index: indexPath.row)
        Style.imageMeal(cell.mealImage)
        cell.mealNameLabel.text = meal.name
        cell.mealPriceLabel.text = "\(meal.price) $"
        cell.mealImage.image = UIImage(named: meal.image)
        return cell
    } 
}
    
   
  
    
    
    

    




