//
//  GroupedRecipesTableViewCell.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/29/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class GroupedRecipesTableViewCell: UITableViewCell {
    
//MARK: Properties
    @IBOutlet weak var RecipeNameLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.RecipeNameLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 24.0)
        self.RecipeNameLabel.textColor = UIColor.black
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
