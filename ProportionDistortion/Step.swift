//
//  Step.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/18/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit
import os.log

class Step: NSObject, NSCoding {
    
//MARK: Properties
    var step: String
    
//MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("steps")
    
//MARK: Types
    
    struct PropertyKey {
        static let step = "step"
    }
    
//MARK: Initialization
    init?(step: String) {
        if step.isEmpty {
            return nil
        }
        self.step = step
    }
    
//MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(step, forKey: PropertyKey.step)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let step = aDecoder.decodeObject(forKey: PropertyKey.step) as? String else {
            os_log("Unable to decode the step from step Object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(step: step)
    }
    
}
