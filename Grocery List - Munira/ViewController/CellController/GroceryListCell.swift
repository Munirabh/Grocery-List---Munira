//
//  GroceryListCell.swift
//  Grocery List - Munira
//
//  Created by Munira on 08/01/2023.
//

import UIKit

class GroceryListCell: UITableViewCell {

    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    func set(item: Items){
        title.text = item.name
        email.text = "\(item.addedByUser.email)"
    }

}
