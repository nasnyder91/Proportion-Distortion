//
//  AddRecipeViewController.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/20/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
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
    var group = "Placeholder"

    override func viewDidLoad() {
        super.viewDidLoad()

        recipeNameTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        name = textField.text
        return true
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
            recipe = Recipe(recipeName: name!, recipeIngredients: ingredients, recipeSteps: steps, recipeGroup: group)
            let navVC = segue.destination as? UINavigationController
            let recipeViewController = navVC?.viewControllers.first as? ShowRecipeViewController
            recipeViewController?.recipe = recipe
        }
    }
 

//MARK: Actions
    @IBAction func unwindToAddRecipe(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? StepsTableViewController {
            var steps = sourceViewController.steps
            steps.remove(at: steps.count-1)
            self.steps = steps
            stepsAddedLabel.text = "\(steps.count) steps added"
        }
        
        if let sourceViewController = sender.source as? IngredientsTableViewController {
            var ingredients = sourceViewController.ingredients
            ingredients.remove(at: ingredients.count-1)
            self.ingredients = ingredients
            ingredientsAddedLabel.text = "\(ingredients.count) ingredients added"
        }
    }
    
}
