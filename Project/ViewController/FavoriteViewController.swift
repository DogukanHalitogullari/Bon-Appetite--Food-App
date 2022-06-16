//
//  FavViewController.swift
//  Project
//
//  Created by Doğukan on 27.12.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class FavoriteViewController: UIViewController {
   
    let style = Style()
    var favId: [String] = []
    var bag:[[String: String]] = []
    let userDataSource = UserDataSource()
    let mealDataSource = MealDataSource()
    let account = AccountViewController()

    @IBOutlet weak var favoriteListCollectionView: UICollectionView!
    @IBOutlet weak var rightTopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        style.rightTopButton(rightTopButton) //call style of right top button accordin to account situation. This is a function and it checks firstly account open or not open in function body
        if (account.checkAccount()) { //check account
            userDataSource.delegate = self
            if let personelid =  Auth.auth().currentUser?.uid {
                userDataSource.getData(userUid: personelid) //get current user data
            }
        } else {
            loadData()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! FavoriteListCollectionViewCell
        if let indexPath = self.favoriteListCollectionView.indexPath(for: cell) {
            let meal = mealDataSource.getMealForId(id: favId[indexPath.row]) //getMealForIndex(index: indexPath.row)
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.amountDetail = 0 
            detailViewController.meal = meal
        }
    }
    
    @IBAction func rightTopButton(_ sender: Any) {
        if (account.checkAccount()) { //if account oepn, go to personel information page and logOut page
            let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AccountVC") as? AccountViewController
            self.navigationController?.pushViewController(screen!, animated: true)
        } else { //if account not open, go to sigin and signup page
            let screen = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogIn") as? LoginPageViewController
            self.navigationController?.pushViewController(screen!, animated: true)
        }
    }
}

extension FavoriteViewController:  UICollectionViewDataSource, UserDataSourceDelegate, MealDataSourceDelegate {
    
    func userDetailLoaded(user: User) {
        self.favId = user.favorite
        mealDataSource.delegate = self
        mealDataSource.get()
    }
    
    func mealListLoaded() {
        favoriteListCollectionView.reloadData()
    }
    
    func loadData() {
        favoriteListCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (account.checkAccount()) {
            return self.favId.count
        }
        return 0 //if acount not open, return 0, this means to no fav meal
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //fav meal initialize on collectionView
        let meal = mealDataSource.getMealForId(id: favId[indexPath.row])
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteListCollectionViewCell
        Style.imageFavList(cell.mealImage)
        cell.mealNameLabel.text = meal.name
        cell.mealPriceLabel.text = "\(meal.price) $"
        cell.mealImage.image = UIImage(named: meal.image)
        collectionView.deselectItem(at: indexPath, animated: false)
        return cell
    }
}

    

