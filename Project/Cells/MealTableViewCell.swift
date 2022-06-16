//
//  MealTableViewCell.swift
//  Project
//
//  Created by Doğukan on 31.12.2021.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    

}
