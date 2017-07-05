//
//  ShowStepsTableViewCell.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/21/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class ShowStepsTableViewCell: UITableViewCell {
    
//MARK: Properties
    @IBOutlet weak var stepsTextView: UITextView!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var editStepsButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.editStepsButton.tintColor = UIColor.gray
        self.editStepsButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 22)
        self.stepsLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 22)

        self.stepsTextView.backgroundColor = UIColor.clear
        self.stepsTextView.textColor = UIColor.black
        self.stepsTextView.font = UIFont(name: "ChalkboardSE-Regular", size: 22)
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
