//
//  Step.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/18/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class Step {
    
//MARK: Properties
    var step: String
    
//MARK: Initialization
    init?(step: String) {
        if step.isEmpty {
            return nil
        }
        self.step = step
    }
}
