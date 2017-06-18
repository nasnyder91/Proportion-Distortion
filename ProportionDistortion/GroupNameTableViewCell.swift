//
//  GroupNameTableViewCell.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/29/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class GroupNameTableViewCell: UITableViewCell {
    
//MARK: Properties
    @IBOutlet weak var groupLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor(red: 231.0/255.0, green: 250.0/255.0, blue: 133.0/255.0, alpha: 1.0)
        self.groupLabel.textColor = UIColor.black
        self.groupLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 14.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
