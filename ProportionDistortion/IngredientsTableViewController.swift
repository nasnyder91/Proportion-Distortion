//
//  IngredientsTableViewController.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/19/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit
import os.log

class IngredientsTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
//MARK: Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var ingredients = [Ingredient]()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSavebuttonState()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAddCell()
        
        updateSavebuttonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredientCellIdentifier = "IngredientTableViewCell"
        let addIngredientCellIdentifier = "AddIngredientTableViewCell"
        
        let currentCellIndex = indexPath.row
        
        if currentCellIndex < ingredients.count-1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ingredientCellIdentifier, for: indexPath) as? IngredientTableViewCell else {
                fatalError("Cell is not of type IngredientTableViewCell")
            }
            let ingredient = ingredients[indexPath.row]
            
            cell.quantityTextField.delegate = cell.self
            cell.unitTextField.delegate = cell.self
            cell.ingredientTextField.delegate = cell.self
            
            cell.quantityTextField.text = ingredient.quantity
            cell.unitTextField.text = ingredient.unit
            cell.ingredientTextField.text = ingredient.ingredient
            
            cell.parentTableView = self
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: addIngredientCellIdentifier, for: indexPath) as? AddIngredientTableViewCell else {
                fatalError("Cell is not of type AddIngredientTableViewCell")
            }
            
            let addIngredient = ingredients[indexPath.row]
            
            cell.addNewIngredientLabel.text = addIngredient.ingredient
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath) as? AddIngredientTableViewCell) != nil {
            let newIngredient = Ingredient()
            
            ingredients.insert(newIngredient, at: ingredients.count-1)
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.insertRows(at: [indexPath], with: .automatic)
            updateSavebuttonState()
        }
        
        
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == ingredients.count-1 {
            return false
        } else {
            return true
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, cancelling.", log: OSLog.default, type: .debug)
            return
        }
        for i in 0..<ingredients.count-1 {
            let cellIndex = IndexPath(row: i, section: 0)
            guard let cell = tableView.cellForRow(at: cellIndex) as? IngredientTableViewCell else {
                fatalError("Cell is not of type IngredientTableViewCell")
            }
            if let quantityText = cell.quantityTextField.text {
                ingredients[i].quantity = quantityText
            }
            if let unitText = cell.unitTextField.text {
                ingredients[i].unit = unitText
            }
            if let ingredientText = cell.ingredientTextField.text {
                ingredients[i].ingredient = ingredientText
            }
        }
    }
    
    @IBAction func cancelAddIngredients(_ sender: UIBarButtonItem) {
        if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
    }
    
    
    
//MARK: Helper Methods
    
    func loadAddCell() {
        let addNewIngredientText = "Add New Ingredient"
        
        guard let newIngredientButtonCell = Ingredient(quantity: "1", unit: "abc", ingredient: addNewIngredientText) else {
            fatalError("Could not create Add New Ingredient cell")
        }
        
        if ingredients.last?.ingredient != addNewIngredientText {
            ingredients += [newIngredientButtonCell]
        }
    }
    func updateSavebuttonState() {
        
        if ingredients.count == 1 {
            
            saveButton.isEnabled = false
            return
        }
        for i in 0..<ingredients.count-1 {
            let newIndexPath = IndexPath(row: i, section: 0)
            let ingredientCell = tableView.cellForRow(at: newIndexPath) as? IngredientTableViewCell
            let ingredientText = ingredientCell?.ingredientTextField.text ?? ""
            
            if ingredientText.isEmpty {
                saveButton.isEnabled = false
            } else {
                saveButton.isEnabled = true
            }
        }
    }
}
