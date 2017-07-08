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
    
    var decimalSlash = UIToolbar()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        // Initialization code
        // initialize custom keyboard
        let keyboardView = UnitKeyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
        keyboardView.delegate = self // the view controller will be notified by the keyboard whenever a key is tapped
        
        // replace system keyboard with custom keyboard
        unitTextField.inputView = keyboardView

        self.quantityTextField.keyboardType = UIKeyboardType.numberPad
        
        createToolBar()
        
        self.quantityTextField.inputAccessoryView = decimalSlash
    }
    
    
    
    func createToolBar() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        decimalSlash = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 55.0))
        decimalSlash.backgroundColor = UIColor.white
        decimalSlash.isTranslucent = false
        decimalSlash.isHidden = false
        decimalSlash.isOpaque = true
        decimalSlash.layer.borderWidth = 0.5
        decimalSlash.layer.borderColor = UIColor.lightGray.cgColor
        
        let slashBarButton = UIBarButtonItem(title: "/", style: UIBarButtonItemStyle.plain, target: self, action: #selector(slashKeyTapped(sender:)))
        slashBarButton.width = screenWidth/2
        slashBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 30)!], for: UIControlState.normal)
        
        let decimalBarButton = UIBarButtonItem(title: ".", style: UIBarButtonItemStyle.plain, target: self, action: #selector(decimalKeyTapped(sender:)))
        decimalBarButton.width = screenWidth/2
        decimalBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 30)!], for: UIControlState.normal)
        
        let midLine = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        midLine.width = 0.5
        
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        decimalSlash.items = [flexibleSpace,slashBarButton,midLine,decimalBarButton,flexibleSpace]
        
        decimalSlash.subviews[1].layer.borderColor = UIColor.lightGray.cgColor
        decimalSlash.subviews[1].layer.borderWidth = 0.5
        
        
    }
    
    func rotated() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        decimalSlash.items?[1].width = screenWidth/2
        decimalSlash.items?[3].width = screenWidth/2
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
    
    func slashKeyTapped(sender: UIBarButtonItem) {
        print("/ tapped")
        if !(quantityTextField.text?.contains("/"))! && !(quantityTextField.text?.contains("."))! {
            quantityTextField.insertText("/")
        } else {
            return
        }
    }
    
    func decimalKeyTapped(sender: UIBarButtonItem) {
        if !(quantityTextField.text?.contains("."))! && !(quantityTextField.text?.contains("/"))! {
            quantityTextField.insertText(".")
        } else {
            return
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
