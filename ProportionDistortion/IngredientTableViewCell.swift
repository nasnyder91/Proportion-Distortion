//
//  IngredientTableViewCell.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/19/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell, UITextFieldDelegate, KeyboardDelegate {
    
//MARK: Properties
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var ingredientTextField: UITextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // initialize custom keyboard
        let keyboardView = UnitKeyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
        keyboardView.delegate = self // the view controller will be notified by the keyboard whenever a key is tapped
        
        // replace system keyboard with custom keyboard
        unitTextField.inputView = keyboardView
    }
    
    // required method for keyboard delegate protocol
    func keyWasTapped(character: String) {
        if character != "Delete" {
            unitTextField.text = ""
            unitTextField.insertText(character)
        } else {
            unitTextField.text = ""
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
