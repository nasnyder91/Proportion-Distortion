//
//  Recipe.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/20/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit
import os.log

class Recipe: NSObject, NSCoding {
    
//MARK: Properties
    var recipeName: String
    var recipeIngredients: [Ingredient]
    var recipeSteps: [Step]
    var recipeGroup: String
    
    
//MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("recipes")
    
//MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let ingredients = "ingredients"
        static let steps = "steps"
        static let group = "group"
    }
    
//MARK: Initialization
    init(recipeName: String, recipeIngredients: [Ingredient], recipeSteps: [Step], recipeGroup: String) {
        self.recipeName = recipeName
        self.recipeIngredients = recipeIngredients
        self.recipeSteps = recipeSteps
        self.recipeGroup = recipeGroup
    }
    
//MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(recipeName, forKey: PropertyKey.name)
        aCoder.encode(recipeIngredients, forKey: PropertyKey.ingredients)
        aCoder.encode(recipeSteps, forKey: PropertyKey.steps)
        aCoder.encode(recipeGroup, forKey: PropertyKey.group)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name from recipe object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let ingredients = aDecoder.decodeObject(forKey: PropertyKey.ingredients) as? [Ingredient] else {
            os_log("Unable to decode the ingredients from recipe object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let steps = aDecoder.decodeObject(forKey: PropertyKey.steps) as? [Step] else {
            os_log("Unable to decode the steps from recipe object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let group = aDecoder.decodeObject(forKey: PropertyKey.group) as? String else {
            os_log("Unable to decode the group from recipe object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(recipeName: name, recipeIngredients: ingredients, recipeSteps: steps, recipeGroup: group)
    }
    
}


