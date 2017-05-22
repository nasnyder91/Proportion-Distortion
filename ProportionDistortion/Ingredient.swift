//
//  Ingredient.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/19/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class Ingredient {
    var quantity: String
    var unit: String
    var ingredient: String
    
    init(quantity: String, unit: String, ingredient: String) {
        self.quantity = quantity
        self.unit = unit
        self.ingredient = ingredient
    }
    init() {
        self.quantity = ""
        self.unit = ""
        self.ingredient = ""
    }
}
