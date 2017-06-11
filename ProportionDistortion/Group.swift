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
    
    var groupNames: [String]?
    
//MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("groups")
    
//MARK: Types
    
    struct PropertyKey {
        static let groups = "groups"
    }
    
//MARK: Initialization
    init(groupNames: [String]) {
        self.groupNames = groupNames
    }
    
//MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(groupNames, forKey: PropertyKey.groups)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let groups = aDecoder.decodeObject(forKey: PropertyKey.groups) as? [String] else {
            os_log("Unable to decode the name from group object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(groupNames: groups)
    }
    
}
