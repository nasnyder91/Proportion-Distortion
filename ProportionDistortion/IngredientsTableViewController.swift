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
    
    var currentEntries: [(Int,String,String,String)] = []
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //updateSavebuttonState()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        loadAddCell()
        if ingredients.count-1 != 0 {
            for i in 0..<ingredients.count-1 {
                currentEntries += [(i,ingredients[i].quantity,ingredients[i].unit,ingredients[i].ingredient)]
            }
        }
        
        
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
            
            let currentIngredient = currentEntries[currentCellIndex]
            
            cell.quantityTextField.delegate = self
            cell.unitTextField.delegate = self
            cell.ingredientTextField.delegate = self
            
            cell.quantityTextField.text = currentIngredient.1
            cell.unitTextField.text = currentIngredient.2
            cell.ingredientTextField.text = currentIngredient.3
            
            
            cell.quantityTextField.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
            cell.unitTextField.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
            cell.ingredientTextField.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
            
            cell.quantityTextField.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
            cell.unitTextField.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
            cell.ingredientTextField.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: addIngredientCellIdentifier, for: indexPath) as? AddIngredientTableViewCell else {
                fatalError("Cell is not of type AddIngredientTableViewCell")
            }
            
            let addIngredient = ingredients[indexPath.row]
            
            cell.addNewIngredientLabel.text = addIngredient.ingredient
            cell.addNewIngredientLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
            
            cell.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
            
            return cell
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath) is AddIngredientTableViewCell) {
            let newIngredient = Ingredient()
            
            ingredients.insert(newIngredient, at: ingredients.count-1)
            currentEntries.append((indexPath.row,"","",""))
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
            currentEntries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateSavebuttonState()
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

    
//MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func ingredientTextFieldDidChange(_ sender: UITextField) {
       
        for i in 0..<currentEntries.count {
            let cellIndex = IndexPath(row: i, section: 0)
            if tableView.cellForRow(at: cellIndex) != nil {
                guard let cell = (tableView.cellForRow(at: cellIndex) as? IngredientTableViewCell)  else {
                    fatalError("Cell is not of type IngredientTableViewCell.")
                }
                if cell.ingredientTextField == sender {
                    currentEntries[i].3 = sender.text!
                    break
                }
            }
        }
        updateSavebuttonState()
    }
    @IBAction func unitTextFieldDidChange(_ sender: UITextField) {
        for i in 0..<currentEntries.count {
            let cellIndex = IndexPath(row: i, section: 0)
            if tableView.cellForRow(at: cellIndex) != nil {
                guard let cell = tableView.cellForRow(at: cellIndex) as? IngredientTableViewCell else {
                    fatalError("Cell is not of type IngredientTableViewCell")
                }
                if cell.unitTextField == sender {
                    currentEntries[i].2 = sender.text!
                    break
                }
            }
        }
    }
    @IBAction func qtyTextFieldDidChange(_ sender: UITextField) {
        for i in 0..<currentEntries.count {
            let cellIndex = IndexPath(row: i, section: 0)
            if tableView.cellForRow(at: cellIndex) != nil {
                guard let cell = tableView.cellForRow(at: cellIndex) as? IngredientTableViewCell else {
                    fatalError("Cell is not of type IngredientTableViewCell")
                }
                if cell.quantityTextField == sender {
                    currentEntries[i].1 = sender.text!
                    break
                }
            }
        }
    }
    
    
    
// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, cancelling.", log: OSLog.default, type: .debug)
            return
        }
        
        for i in 0..<currentEntries.count {
            ingredients[i].quantity = currentEntries[i].1
            
            ingredients[i].unit = currentEntries[i].2
            
            ingredients[i].ingredient = currentEntries[i].3
            
            /*let cellIndex = IndexPath(row: i, section: 0)
            if tableView.cellForRow(at: cellIndex) != nil {
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
            }*/
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
        
        let newIngredientButtonCell = Ingredient(quantity: "1", unit: "abc", ingredient: addNewIngredientText) //else {
           // fatalError("Could not create Add New Ingredient cell")
        //}
        
        if ingredients.last?.ingredient != addNewIngredientText {
            ingredients += [newIngredientButtonCell]
        }
    }
    func updateSavebuttonState() {
        
        if currentEntries.count == 0 {
            
            saveButton.isEnabled = false
            return
        }
        
        for i in 0..<currentEntries.count {
            if currentEntries[i].3 == "" {
                print("ingredient at \(i) is empty")
            }
            print(currentEntries[i].3)
            if currentEntries[i].3.isEmpty || currentEntries[i].3 == "" {
                saveButton.isEnabled = false
                return
            } else {
                saveButton.isEnabled = true
            }
        }
        /*
        for i in 0..<currentEntries.count {
            let newIndexPath = IndexPath(row: i, section: 0)
            if tableView.cellForRow(at: newIndexPath) != nil {
                guard let ingredientCell = tableView.cellForRow(at: newIndexPath) as? IngredientTableViewCell else {
                    return
                }
                let ingredientText = ingredientCell.ingredientTextField.text ?? ""
                
                if ingredientText.isEmpty || ingredientText == "" {
                    saveButton.isEnabled = false
                    return
                } else {
                    saveButton.isEnabled = true
                }
            }
        }*/
    }
}
