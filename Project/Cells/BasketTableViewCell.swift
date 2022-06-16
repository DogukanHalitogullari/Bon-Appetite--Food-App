//
//  BasketTableViewCell.swift
//  Project
//
//  Created by Doğukan on 9.01.2022.
//

import UIKit

class BasketTableViewCell: UITableViewCell {

    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealPriceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
