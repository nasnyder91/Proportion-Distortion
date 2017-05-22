//
//  ProportionDistortionViewController.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/29/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit
import os.log

class ProportionDistortionViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
//MARK: Properties
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var addRecipeButton: UIButton!
    @IBOutlet weak var addGroupButton: UIButton!
    @IBOutlet weak var proportionDistortionLabel: UILabel!
    
    var groups = [Group]()
    var recipeList = AllRecipes()
    
    var recipeSearchResults = [Recipe]()
    let searchResultsTable = UITableViewController()
    var resultsSearchController = UISearchController()
    
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedRecipes = loadRecipes() {
            recipeList.allRecipes = savedRecipes
        } else {
            loadSampleGroupRecipes()
        }
        
        loadGroups()
        organizeGroupsAndRecipes()
        self.extendedLayoutIncludesOpaqueBars = !(self.navigationController?.navigationBar.isTranslucent)!
        navigationItem.hidesBackButton = true
        
        self.groupsTableView.delegate = self
        self.groupsTableView.dataSource = self
        
        self.searchResultsTable.tableView.delegate = self
        self.searchResultsTable.tableView.dataSource = self
        
        self.resultsSearchController = (UISearchController(searchResultsController: searchResultsTable))
        self.resultsSearchController.searchResultsUpdater = self
        self.resultsSearchController.hidesNavigationBarDuringPresentation = false
        self.resultsSearchController.delegate = self
        
        
        let searchBar = resultsSearchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search your recipes"
        self.view.addSubview(searchBar)
        
        let searchBarLocation = proportionDistortionLabel.frame.origin.y + proportionDistortionLabel.frame.size.height
        searchBar.frame.origin.y = searchBarLocation
        
        let searchBarBottomAnchor = searchBar.bottomAnchor
        
        groupsTableView.topAnchor.constraint(equalTo: searchBarBottomAnchor, constant: 8.0).isActive = true


        self.resultsSearchController.hidesNavigationBarDuringPresentation = false
        self.resultsSearchController.dimsBackgroundDuringPresentation = true
        self.definesPresentationContext = true
    
        
        self.addRecipeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addRecipeButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        
        // Do any additional setup after loading the view.
    }

    func layoutSubview() {
        
        self.resultsSearchController = (UISearchController(searchResultsController: searchResultsTable))
        self.resultsSearchController.searchResultsUpdater = self
        self.resultsSearchController.hidesNavigationBarDuringPresentation = false
        self.resultsSearchController.delegate = self
        
        
        let searchBar = resultsSearchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search your recipes"
        self.view.addSubview(searchBar)
        
        let searchBarLocation = proportionDistortionLabel.frame.origin.y + proportionDistortionLabel.frame.size.height
        searchBar.frame.origin.y = searchBarLocation
        
        let searchBarBottomAnchor = searchBar.bottomAnchor
        
        groupsTableView.topAnchor.constraint(equalTo: searchBarBottomAnchor, constant: 8.0).isActive = true
        
        
        self.resultsSearchController.hidesNavigationBarDuringPresentation = false
        self.resultsSearchController.dimsBackgroundDuringPresentation = true
        self.definesPresentationContext = true
    }
    
//MARK: TableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultsSearchController.isActive {
            return self.recipeSearchResults.count 
        } else {
            return self.groups.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("AddingCell")
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "GroupNameCell") as? GroupNameTableViewCell
        
        if cell == nil {
            tableView.register(GroupNameTableViewCell.classForCoder(), forCellReuseIdentifier: "GroupNameCell")
            
            cell = GroupNameTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "GroupNameCell")
        }
        
        var cellTitles = [String]()
        
        if self.resultsSearchController.isActive {
            for r in recipeSearchResults {
                cellTitles.append(r.recipeName)
            }
        } else {
            for g in groups {
                cellTitles.append(g.groupName)
            }
        }
        
        let title = cellTitles[indexPath.row]
        
        if let label = cell?.groupLabel{
            label.text = title
        } else {
            cell?.textLabel?.text = title
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.resultsSearchController.isActive {
            performSegue(withIdentifier: "ShowSearchedRecipe", sender: searchResultsTable.tableView.cellForRow(at: indexPath))
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.resultsSearchController.isActive {
            return 0
        }
        return 35.0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recipe Groups"
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
            
            showGroupViewController.recipeList = self.recipeList
            showGroupViewController.recipes = selectedGroup.groupRecipes
            print(selectedGroup.groupRecipes.count)
            showGroupViewController.navigationItem.title = selectedGroup.groupName
            
        case "AddNewRecipe":
            os_log("Adding a new recipe", log: OSLog.default, type: .debug)
            guard let addRecipeNavController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let addRecipeViewController = addRecipeNavController.viewControllers.first as? AddRecipeViewController else {
                fatalError("Nav controller is not presenting AddRecipeViewController")
            }
            addRecipeViewController.recipeList = self.recipeList
            addRecipeViewController.groupsList = self.groups
            
        case "ShowSearchedRecipe":
            guard let recipeViewController = segue.destination as? ShowRecipeViewController else {
                fatalError("Segue did not point to ShowRecipeViewController")
            }
            guard let selectedRecipeCell = sender as? GroupNameTableViewCell else {
                fatalError("Sender was not a GroupNameTableViewCell")
            }
            guard let indexPath = searchResultsTable.tableView.indexPath(for: selectedRecipeCell) else {
                fatalError("The selected cell is not in the table")
            }
            let recipe = recipeSearchResults[indexPath.row]
            
            recipeViewController.recipeList = self.recipeList
            recipeViewController.recipe = recipe
            recipeViewController.distortedIngredients = recipe.recipeIngredients
            recipeViewController.navigationItem.title = recipe.recipeName
            
        case "AddNewGroup": break
            
            
        default:
            fatalError("Unexpected segue identifier: \(segue.identifier)")
        }
    }
    
    @IBAction func unwindToMain(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddNewGroupViewController {
            let recipes = [Recipe]()
            let newGroupName = sourceViewController.newGroupName
            let newGroup = Group(groupName: newGroupName!, groupRecipes: recipes)
            self.groups.append(newGroup)
            groupsTableView.reloadData()
        }
    }
    
//MARK: Search Functions
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.recipeSearchResults = self.recipeList.allRecipes.filter{ (aRecipe: Recipe) -> Bool in
            aRecipe.recipeName.lowercased().range(of: searchText.lowercased()) != nil
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        self.recipeSearchResults.removeAll(keepingCapacity: false)
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        self.searchResultsTable.tableView.reloadData()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.searchResultsTable.tableView.sizeToFit()
        self.searchResultsTable.tableView.addSubview(searchController.searchBar)
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        print("Dismissed")
        self.navigationController?.navigationBar.isTranslucent = false
        self.layoutSubview()
    }
    
//MARK: Private Methods
    private func loadGroups() {
        let recipes = [Recipe]()
        var usedGroups = [String]()
        
        for i in 0..<recipeList.allRecipes.count {
            if !(usedGroups.contains(recipeList.allRecipes[i].recipeGroup)) {
                let group = Group(groupName: recipeList.allRecipes[i].recipeGroup, groupRecipes: recipes)
                groups += [group]
                usedGroups.append(group.groupName)
            }
        }
    }
    
    private func loadSampleGroupRecipes() {
        let ingredients = [Ingredient]()
        let steps = [Step]()
        
        let recipe1 = Recipe(recipeName: "Poo", recipeIngredients: ingredients , recipeSteps: steps, recipeGroup: "Soups")
        let recipe2 = Recipe(recipeName: "Pee", recipeIngredients: ingredients, recipeSteps: steps, recipeGroup: "Chicken")
        let recipe3 = Recipe(recipeName: "Barf", recipeIngredients: ingredients, recipeSteps: steps, recipeGroup: "Mexican")
        
        //recipeList.addRecipe(recipe: recipe1)
        //recipeList.addRecipe(recipe: recipe2)
        //recipeList.addRecipe(recipe: recipe3)
        recipeList.allRecipes += [recipe1]
        recipeList.allRecipes += [recipe2]
        recipeList.allRecipes += [recipe3]
    }
    
    private func organizeGroupsAndRecipes() {
        for r in recipeList.allRecipes {
            for i in 0..<groups.count {
                if r.recipeGroup == groups[i].groupName {
                    groups[i].groupRecipes.append(r)
                }
            }
        }
    }
    
    func saveRecipes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(recipeList.allRecipes, toFile: Recipe.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Recipes successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save recipes...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadRecipes() -> [Recipe]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Recipe.ArchiveURL.path) as? [Recipe]
    }

}
