//
//  AllRecipes.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 4/2/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit
import os.log

class AllRecipes {
    
//MARK: Properties
    var allRecipes = [Recipe]()
    
//MARK: Functions

    func addRecipe(recipe: Recipe) {
        allRecipes += [recipe]
    }
    
    func deleteRecipe(recipe: Recipe) {
        for i in 0..<allRecipes.count {
            if allRecipes[i] === recipe {
                allRecipes.remove(at: i)
                return
            } else {
                os_log("The recipe was not in the list of recipes and therefore could not be deleted", log: OSLog.default, type: .debug)
            }
        }
    }
    
    func recipeArray() -> [Recipe] {
        return allRecipes
    }
}
