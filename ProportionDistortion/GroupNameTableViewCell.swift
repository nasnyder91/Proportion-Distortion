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
        
        self.backgroundColor = UIColor.black
        self.groupLabel.textColor = UIColor.white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
