//
//  GroceryCell.swift
//  Grocery List - Munira
//
//  Created by Munira on 10/01/2023.
//

import UIKit

class GroceryCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func set(item: Items){
        itemLabel.text = item.name
        emailLabel.text = "\(item.addedByUser.email)"
    }
}
