//
//  AddRecipeViewController.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/20/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate {
    
//MARK: Properties
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var ingredientsAddedLabel: UILabel!
    @IBOutlet weak var stepsAddedLabel: UILabel!
    @IBOutlet weak var recipeGroupLabel: UILabel!
    
    //Buttons
    @IBOutlet weak var addIngredientsButton: UIButton!
    @IBOutlet weak var addStepsButton: UIButton!
    @IBOutlet weak var addGroupButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //Data
    var recipe: Recipe?
    var name: String?
    var steps = [Step]()
    var ingredients = [Ingredient]()
    var group = ""
    var recipeList: AllRecipes?
    var groupsList: [String]?
    
    var groupsPickerView = UIPickerView()
    var groupChoices = [String]()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customCancel = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelAdding(_:)))
        
        self.navigationItem.leftBarButtonItem = customCancel
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 225.0/255.0, green: 60.0/255.0, blue: 0/255.0, alpha: 1.0), NSFontAttributeName: UIFont(name: "ChalkboardSE-Regular", size: 22)!]
        self.navigationController?.navigationBar.tintColor = UIColor(red: 29.0/255.0, green: 55.0/255.0, blue: 3.0/255.0, alpha: 1.0)

        
        self.view.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.ingredientsAddedLabel.textColor = UIColor.gray
        self.ingredientsAddedLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        
        self.stepsAddedLabel.textColor = UIColor.gray
        self.stepsAddedLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        
        self.recipeGroupLabel.textColor = UIColor.gray
        self.recipeGroupLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        
        self.recipeNameTextField.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.recipeNameTextField.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        
        self.addIngredientsButton.setTitleColor(UIColor(red: 29.0/255.0, green: 55.0/255.0, blue: 3.0/255.0, alpha: 1.0), for: .normal)
        self.addIngredientsButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        
        self.addStepsButton.setTitleColor(UIColor(red: 29.0/255.0, green: 55.0/255.0, blue: 3.0/255.0, alpha: 1.0), for: .normal)
        self.addStepsButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        
        self.addGroupButton.setTitleColor(UIColor(red: 29.0/255.0, green: 55.0/255.0, blue: 3.0/255.0, alpha: 1.0), for: .normal)
        self.addGroupButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        


        recipeNameTextField.delegate = self
        
        for i in 0..<(groupsList?.count ?? 0) {
            groupChoices.append((groupsList?[i])!)
        }
        
        
        self.groupsPickerView.delegate = self
        self.groupsPickerView.dataSource = self
        self.groupsPickerView.backgroundColor = UIColor.white
        self.groupsPickerView.isHidden = true
        self.groupsPickerView.isOpaque = true
        self.view.addSubview(groupsPickerView)
        self.groupsPickerView.translatesAutoresizingMaskIntoConstraints = false
        self.groupsPickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.groupsPickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.groupsPickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.groupsPickerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4, constant: 0.0)
        self.groupsPickerView.selectRow(2, inComponent: 0, animated: false)
        
        
        
        
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        name = textField.text
        //updateSaveButtonState()
        return true
    }
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
//MARK: UIPickerViewDelegate and DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupChoices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var groupChoiceString: String
        
        groupChoiceString = groupChoices[row]
        
        return groupChoiceString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.group = groupChoices[row]
        self.recipeGroupLabel.text = groupChoices[row]
        pickerView.isHidden = true
    }
    

// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let button = sender as? UIButton, button == addStepsButton {
            if steps.count > 0 {
                guard let destinationViewController = segue.destination as? StepsTableViewController else {
                    fatalError("segue did not point to StepsTableViewController")
                }
                destinationViewController.steps = steps
                destinationViewController.loadAddCell()
            }
        }
        
        if let button = sender as? UIButton, button == addIngredientsButton {
            if ingredients.count > 0 {
                guard let destinationViewController = segue.destination as? IngredientsTableViewController else {
                    fatalError("segue did not point to IngredientsTableViewController")
                }
                destinationViewController.ingredients = ingredients
                destinationViewController.loadAddCell()
            }
        }
        
        if let button = sender as? UIBarButtonItem, button === saveButton {
            guard let recipeViewController = segue.destination as? ShowRecipeViewController else {
                fatalError("Segue did not point to ShowRecipeViewController")
            }
            name = recipeNameTextField.text ?? ""
            recipe = Recipe(recipeName: name!, recipeIngredients: ingredients, recipeSteps: steps, recipeGroup: group)

            recipeViewController.recipe = recipe
            recipeViewController.distortedIngredients = ingredients
            recipeViewController.navigationItem.title = name
            recipeList?.allRecipes += [recipe!]
            recipeViewController.recipeList = self.recipeList
            recipeViewController.cameFromAdd = true
            recipeViewController.allGroups = groupsList!
            
            
            recipeViewController.navigationItem.setHidesBackButton(true, animated: false)
        }
    }
 

//MARK: Actions
    @IBAction func unwindToAddRecipe(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? StepsTableViewController {
            var steps = sourceViewController.steps
            steps.remove(at: steps.count-1)
            self.steps = steps
            stepsAddedLabel.text = "\(steps.count) steps added"
            updateSaveButtonState()
        }
        
        if let sourceViewController = sender.source as? IngredientsTableViewController {
            var ingredients = sourceViewController.ingredients
            ingredients.remove(at: ingredients.count-1)
            self.ingredients = ingredients
            ingredientsAddedLabel.text = "\(ingredients.count) ingredients added"
            updateSaveButtonState()
        }
    }
    
    @IBAction func chooseGroupButton(_ sender: UIButton) {
        self.groupsPickerView.isHidden = false
    }
    
    @IBAction func cancelAdding(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Cancel this recipe?", message: "You will lose all recipe information.\nDo you wish to continue?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes, Cancel Recipe", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "No, Continue Recipe", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
            return
        }))
        
        present(alert, animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
    }
    
    
//MARK: Private Methods
    private func updateSaveButtonState() {
        let name = recipeNameTextField.text ?? ""
        //let ingredients = ingredientsAddedLabel.text
        //let steps = stepsAddedLabel.text
        //let group = recipeGroupLabel.text ?? ""
        /*
        if !name.isEmpty && !group.isEmpty && ingredients![ingredients!.startIndex] != "0" && steps![steps!.startIndex] != "0" {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }*/
        if !name.isEmpty {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
}
