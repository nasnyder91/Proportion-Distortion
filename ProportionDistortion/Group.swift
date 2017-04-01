//
//  Group.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/29/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit


class Group{
    var groupName: String
    var groupRecipes: [Recipe]
    
    
    init(groupName: String, groupRecipes: [Recipe]) {
        self.groupName = groupName
        self.groupRecipes = groupRecipes
    }
}
