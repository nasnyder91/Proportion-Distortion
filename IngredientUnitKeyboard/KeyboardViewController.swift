//
//  KeyboardViewController.swift
//  IngredientUnitKeyboard
//
//  Created by Dingy Pumba on 5/16/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class IngredientUnitKeyboard: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var cupsButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardButtons()
        
        // Perform custom UI setup here
        
    }
    
    func addKeyboardButtons() {
        addCups()
    }
    
    func addCups() {
        // Initialize the button
        self.cupsButton = UIButton(type: .system)
        
        self.cupsButton.setTitle(NSLocalizedString("Cups", comment: "Cups"), for: [])
        self.cupsButton.sizeToFit()
        self.cupsButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.cupsButton.addTarget(self, action: #selector(self.didTapCups), for: .touchUpInside)
        
        self.view.addSubview(self.cupsButton)
        
        self.cupsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.cupsButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func didTapCups() {
        let proxy = textDocumentProxy as UITextDocumentProxy
        
        proxy.insertText("Cups")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
