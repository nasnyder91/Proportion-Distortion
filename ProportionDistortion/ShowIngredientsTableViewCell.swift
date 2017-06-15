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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.black
        self.ingredientsTextView.backgroundColor = UIColor.clear
        self.ingredientsTextView.textColor = UIColor.blue
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
