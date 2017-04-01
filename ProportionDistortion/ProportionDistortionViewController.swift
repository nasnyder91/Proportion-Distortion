//
//  ProportionDistortionViewController.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/29/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit
import os.log

class ProportionDistortionViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
//MARK: Properties
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var searchRecipesBar: UISearchBar!
    @IBOutlet weak var addRecipeButton: UIButton!
    @IBOutlet weak var addGroupButton: UIButton!
    
    var groups = [Group]()
    var groupRecipes = [Recipe]()
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleGroupRecipes()
        loadDefaultGroups()
        organizeGroupsAndRecipes()
        
        self.groupsTableView.delegate = self
        self.groupsTableView.dataSource = self
        self.searchRecipesBar.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        
        self.addRecipeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addRecipeButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//MARK: TableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupNameCell", for: indexPath) as? GroupNameTableViewCell else {
            fatalError("Cell is not of type GroupNameTableViewCell")
        }
        let group = groups[indexPath.row]
        
        cell.groupLabel.text = group.groupName
        
        return cell
    }

    
// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "ShowGroupedRecipesList":
            guard let showGroupViewController = segue.destination as? GroupedRecipesTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedGroupNameCell = sender as? GroupNameTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = groupsTableView.indexPath(for: selectedGroupNameCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedGroup = groups[indexPath.row]
            
            showGroupViewController.recipes = selectedGroup.groupRecipes
            showGroupViewController.navigationItem.title = selectedGroup.groupName
            
        case "AddNewRecipe":
            os_log("Adding a new recipe", log: OSLog.default, type: .debug)
            
        default:
            fatalError("Unexpected segue identifier: \(segue.identifier)")
        }
    }
    
    
    
//MARK: Private Methods
    private func loadDefaultGroups() {
        let recipes = [Recipe]()
        
        let soupGroup = Group(groupName: "Soups", groupRecipes: recipes)
        let chickenGroup = Group(groupName: "Chicken", groupRecipes: recipes)
        let mexicanGroup = Group(groupName: "Mexican", groupRecipes: recipes)
        
        groups += [soupGroup, chickenGroup, mexicanGroup]
    }
    
    private func loadSampleGroupRecipes() {
        let ingredients = [Ingredient]()
        let steps = [Step]()
        
        let recipe1 = Recipe(recipeName: "Poo", recipeIngredients: ingredients , recipeSteps: steps, recipeGroup: "Soups")
        let recipe2 = Recipe(recipeName: "Pee", recipeIngredients: ingredients, recipeSteps: steps, recipeGroup: "Chicken")
        let recipe3 = Recipe(recipeName: "Barf", recipeIngredients: ingredients, recipeSteps: steps, recipeGroup: "Mexican")
        
        groupRecipes += [recipe1,recipe2,recipe3]
    }
    
    private func organizeGroupsAndRecipes() {
        for r in groupRecipes {
            for i in 0..<groups.count {
                if r.recipeGroup == groups[i].groupName {
                    groups[i].groupRecipes.append(r)
                }
            }
        }
    }

}
