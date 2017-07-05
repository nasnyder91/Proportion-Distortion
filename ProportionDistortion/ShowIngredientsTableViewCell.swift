//
//  ShowIngredientsTableViewCell.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/21/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class ShowIngredientsTableViewCell: UITableViewCell, UITextViewDelegate {
    
//MARK: Properties
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var editIngredientsButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.ingredientsLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 22)

        self.editIngredientsButton.tintColor = UIColor.gray
        self.editIngredientsButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 22)
        self.ingredientsTextView.backgroundColor = UIColor.clear
        self.ingredientsTextView.textColor = UIColor.black
        self.ingredientsTextView.font = UIFont(name: "ChalkboardSE-Regular", size: 22)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
