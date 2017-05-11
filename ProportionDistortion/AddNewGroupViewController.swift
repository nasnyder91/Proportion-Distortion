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
        
        self.navigationItem.title = "Add New Group"
        //self.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil), animated: true)
        //self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil), animated: true)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveGroup(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAddGroup(_:)))
        
        groupNameTextField.delegate = self
        
        updateSaveButtonState()
    }
    
    
//MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newGroupName = groupNameTextField.text
        
        updateSaveButtonState()
        
        return true
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
