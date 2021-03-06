//
//  GroupedRecipesTableViewController.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/29/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit

class GroupedRecipesTableViewController: UITableViewController, UINavigationControllerDelegate {
    
//MARK: Properties
    var recipeList = AllRecipes()
    var recipes = [Recipe]()
    var groupsList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.tableView.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.tableView.separatorColor = UIColor(red: 225.0/255.0, green: 60.0/255.0, blue: 0/255.0, alpha: 1.0)
        
                       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? GroupedRecipesTableViewCell else {
            fatalError("Cell is not of type GroupedRecipesTableViewCell")
        }
        
        let recipe = recipes[indexPath.row]
        
        cell.RecipeNameLabel.text = recipe.recipeName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            recipes.remove(at: indexPath.row)
            let cell = tableView.cellForRow(at: indexPath) as? GroupedRecipesTableViewCell
            let currentRecipe = cell?.RecipeNameLabel.text
            for r in recipeList.allRecipes {
                if r.recipeName == currentRecipe! {
                    recipeList.deleteRecipe(recipe: r)
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
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
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "ShowRecipe":
            guard let recipeViewController = segue.destination as? ShowRecipeViewController else {
                fatalError("Segue did not point to ShowRecipeViewController")
            }
            guard let selectedRecipeCell = sender as? GroupedRecipesTableViewCell else {
                fatalError("Sender was not a GroupedRecipesTableViewCell")
            }
            guard let indexPath = tableView.indexPath(for: selectedRecipeCell) else {
                fatalError("The selected cell is not in the table")
            }
            let recipe = recipes[indexPath.row]
            
            recipeViewController.recipeList = self.recipeList
            recipeViewController.recipe = recipe
            recipeViewController.distortedIngredients = recipe.recipeIngredients
            recipeViewController.allGroups = groupsList
            recipeViewController.navigationItem.title = recipe.recipeName
            
        case "AddNewGroupRecipe":
            guard let addRecipeNavController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let addRecipeViewController = addRecipeNavController.viewControllers.first as? AddRecipeViewController else {
                fatalError("Nav controller is not presenting AddRecipeViewController")
            }
            addRecipeViewController.recipeList = self.recipeList
            var groups = [String]()
            for r in recipeList.allRecipes{
                if !(groups.contains(r.recipeGroup)) && r.recipeGroup != "" {
                    groups += [r.recipeGroup]
                }
            }
            let allRecipesGroupIndex = groups.index(of: "All Recipes")
            if allRecipesGroupIndex != 0 && allRecipesGroupIndex != nil {
                groups.remove(at: allRecipesGroupIndex!)
                groups.insert("All Recipes", at: 0)
            } else if allRecipesGroupIndex == nil {
                groups.insert("All Recipes", at: 0)
            }
            
            addRecipeViewController.groupsList = groups
            
        default:
            fatalError("Unexpected segue identifier: \(String(describing: segue.identifier))")
        }
    }
}
