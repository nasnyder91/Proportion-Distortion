//
//  ShowRecipeViewController.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/21/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class ShowRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UINavigationControllerDelegate {
    
//MARK: Properties
    @IBOutlet weak var recipeTableView: UITableView!
    
    
    var recipe: Recipe?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recipeTableView.delegate = self
        self.recipeTableView.dataSource = self
        
        //Automatically adjust cells to fit textview size
        self.recipeTableView.estimatedRowHeight = 50
        self.recipeTableView.rowHeight = UITableViewAutomaticDimension
        self.recipeTableView.setNeedsLayout()
        self.recipeTableView.layoutIfNeeded()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredientsIdentifier = "ShowIngredientsCell"
        let stepsIdentifier = "ShowStepsCell"
        
        switch (indexPath.row) {
        case 0:
            print("Hi1")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ingredientsIdentifier, for: indexPath) as? ShowIngredientsTableViewCell else {
                fatalError("Cell is not of type ShowIngredientsTableViewCell")
            }
            var ingredientsText = ""
            
            if let ingredientsList = recipe?.recipeIngredients {
                for i in 0..<ingredientsList.count {
                    let ingredient = ingredientsList[i]
                    
                    if i < ingredientsList.count-1 {
                        ingredientsText += "\u{2022} \(ingredient.quantity) \(ingredient.unit) \(ingredient.ingredient)\n"
                    } else {
                        ingredientsText += "\u{2022} \(ingredient.quantity) \(ingredient.unit) \(ingredient.ingredient)"
                    }
                    
                }
            }
            
            cell.ingredientsTextView.text = ingredientsText
            cell.ingredientsTextView.sizeToFit()
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: stepsIdentifier, for: indexPath) as? ShowStepsTableViewCell else {
                fatalError("Cell is not of type ShowStepsTableViewCell")
            }
            var stepsText = ""
            
            if let stepsList = recipe?.recipeSteps {
                for i in 0..<stepsList.count {
                    let step = stepsList[i]
                    
                    if i < stepsList.count-1 {
                        stepsText += "Step \(i+1): \(step.step)\n\n"
                    } else {
                        stepsText += "Step \(i+1): \(step.step)"
                    }
                }
            }
            
            cell.stepsTextView.text = stepsText
            cell.stepsTextView.sizeToFit()
            
            return cell
            
        default:
            fatalError("Could not create cell")
        }
     }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

    

    
// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        switch (segue.identifier ?? "") {
            
        case "EditIngredients":
            guard let editIngredientsViewController = segue.destination as? IngredientsTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            let ingredients = recipe?.recipeIngredients
            editIngredientsViewController.ingredients = ingredients!
            
        case "EditSteps":
            guard let editStepsViewController = segue.destination as? StepsTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            if let steps = recipe?.recipeSteps {
                editStepsViewController.steps = steps
            }
            editStepsViewController.loadAddCell()
            
        default:
            fatalError("Unexpected segue identifier: \(segue.identifier)")
        }
        
    }
    
//MARK: Actions
    @IBAction func unwindToRecipe(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? IngredientsTableViewController {
            var ingredients = sourceViewController.ingredients
            
            ingredients.remove(at: ingredients.count-1)
            
            recipe?.recipeIngredients = ingredients
            
            recipeTableView.reloadData()
        }
        if let sourceViewController = sender.source as? StepsTableViewController {
            var steps = sourceViewController.steps
            
            steps.remove(at: steps.count-1)
            
            recipe?.recipeSteps = steps
            
            recipeTableView.reloadData()
        }
    }

    
}
