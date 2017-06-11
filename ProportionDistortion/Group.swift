//
//  Group.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/29/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit
import os.log

class Group: NSObject, NSCoding {
    
    var groupName: String
    var groupRecipes: [Recipe]
    
//MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("groups")
    
//MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let recipes = "recipes"
    }
    
//MARK: Initialization
    init(groupName: String, groupRecipes: [Recipe]) {
        self.groupName = groupName
        self.groupRecipes = groupRecipes
    }
    
//MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(groupName, forKey: PropertyKey.name)
        aCoder.encode(groupRecipes, forKey: PropertyKey.recipes)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name from group object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let recipes = aDecoder.decodeObject(forKey: PropertyKey.recipes) as? [Recipe] else {
            os_log("Unable to decode the recipes from group object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(groupName: name, groupRecipes: recipes)
    }
    
}
