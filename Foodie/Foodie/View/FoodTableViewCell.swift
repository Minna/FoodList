//
//  FoodTableViewCell.swift
//  Foodie
//
//  Created by Minna on 24/07/21.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteButton: UIButton!
    var favoriteButtonAction : (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favoriteButtonTapped(_ sender: UIButton){
        favoriteButtonAction?()
      }

}
