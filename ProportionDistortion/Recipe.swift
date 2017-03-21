//
//  Recipe.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/20/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class Recipe {
    var recipeName: String
    var recipeIngredients: [Ingredient]
    var recipeSteps: [Step]
    var recipeGroup: String
    
    init(recipeName: String, recipeIngredients: [Ingredient], recipeSteps: [Step], recipeGroup: String) {
        self.recipeName = recipeName
        self.recipeIngredients = recipeIngredients
        self.recipeSteps = recipeSteps
        self.recipeGroup = recipeGroup
    }
}
