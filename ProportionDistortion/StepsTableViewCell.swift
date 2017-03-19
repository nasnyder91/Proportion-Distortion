//
//  StepsTableViewCell.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/18/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class StepsTableViewCell: UITableViewCell {
    
//MARK: Properties
    @IBOutlet weak var step: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
