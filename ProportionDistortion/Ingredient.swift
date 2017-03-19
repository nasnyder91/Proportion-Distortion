//
//  Ingredient.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/19/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class Ingredient {
    var quantity: Int
    var unit: String
    var ingredient: String
    
    init?(quantity: Int, unit: String, ingredient: String) {
        if quantity < 1 || unit.isEmpty || ingredient.isEmpty {
            return nil
        }
        self.quantity = quantity
        self.unit = unit
        self.ingredient = ingredient
    }
}
