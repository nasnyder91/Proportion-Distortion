//
//  AddRecipeViewController.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/20/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        updateSaveButtonState()
        return true
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
        dismiss(animated: true, completion: nil)
    }
    
    
//MARK: Private Methods
    private func updateSaveButtonState() {
        let name = recipeNameTextField.text ?? ""
        let ingredients = ingredientsAddedLabel.text
        let steps = stepsAddedLabel.text
        let group = recipeGroupLabel.text ?? ""
        
        if !name.isEmpty && !group.isEmpty && ingredients![ingredients!.startIndex] != "0" && steps![steps!.startIndex] != "0" {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
}
