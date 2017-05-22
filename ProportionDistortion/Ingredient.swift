//
//  Ingredient.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/19/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit
import os.log

class Ingredient: NSObject, NSCoding {
    var quantity: String
    var unit: String
    var ingredient: String
    
//MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("ingredients")
    
//MARK: Types
    
    struct PropertyKey {
        static let quantity = "quantity"
        static let unit = "unit"
        static let ingredient = "ingredient"
    }

//MARK: Initialization
    
    init(quantity: String, unit: String, ingredient: String) {
        self.quantity = quantity
        self.unit = unit
        self.ingredient = ingredient
    }
    override init() {
        self.quantity = ""
        self.unit = ""
        self.ingredient = ""
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(quantity, forKey: PropertyKey.quantity)
        aCoder.encode(unit, forKey: PropertyKey.unit)
        aCoder.encode(ingredient, forKey: PropertyKey.ingredient)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let quantity = aDecoder.decodeObject(forKey: PropertyKey.quantity) as? String
        
        let unit = aDecoder.decodeObject(forKey: PropertyKey.unit) as? String
        
        guard let ingredient = aDecoder.decodeObject(forKey: PropertyKey.ingredient) as? String else {
            os_log("Unable to decode the ingredient from ingredient Object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(quantity: quantity!, unit: unit!, ingredient: ingredient)
    }
    
}
