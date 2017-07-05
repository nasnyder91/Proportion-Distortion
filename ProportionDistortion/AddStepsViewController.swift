//
//  AddStepsViewController.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/18/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit
import os.log


class AddStepsViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    
//MARK: Properties
    @IBOutlet weak var addStepTextField: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var step: Step?
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.addStepTextField.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.addStepTextField.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        
        addStepTextField.delegate = self
        addStepTextField.becomeFirstResponder()
        
        if let step = step {
            addStepTextField.text = step.step
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

// MARK: - Navigation
    @IBAction func cancelAddStep(_ sender: UIBarButtonItem) {
        
        if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("AddStepViewController is not in a navigation controller")
        }
    }

    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, cancelling.", log: OSLog.default, type: .debug)
            return
        }
        
        let stepEntry = addStepTextField.text ?? ""
        
        step = Step(step: stepEntry)
    }
    

}
