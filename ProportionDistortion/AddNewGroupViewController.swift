//
//  AddNewGroupViewController.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 5/7/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class AddNewGroupViewController: UIViewController, UITextFieldDelegate {
    
//MARK: Properties
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    var newGroupName: String?
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.groupNameTextField.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        
        self.groupNameTextField.font = UIFont(name: "ChalkboardSE-Regular", size: 24.0)
        
        self.navigationItem.title = "Add New Group"
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveGroup(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAddGroup(_:)))
        
        groupNameTextField.delegate = self
        
        updateSaveButtonState()
    }
    
    
//MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        newGroupName = groupNameTextField.text
        
        //updateSaveButtonState()
        
        return true
    }
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    

    
// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === self.navigationItem.rightBarButtonItem else{
            return
        }
        
        newGroupName = groupNameTextField.text
    }
    @IBAction func saveGroup(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
//MARK: Actions
    @IBAction func cancelAddGroup(_ sender: UIBarButtonItem) {
        print("Cancelling")
        if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }

    }
    
//MARK: Private Methods
    
    private func updateSaveButtonState() {
        let groupName = groupNameTextField.text ?? ""
        
        if !groupName.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}
