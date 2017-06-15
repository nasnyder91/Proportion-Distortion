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
    
    var groups = [String]()
    var recipeList = AllRecipes()
    
    var recipeSearchResults = [Recipe]()
    let searchResultsTable = UITableViewController()
    var resultsSearchController = UISearchController()
    
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.red]

        
        self.view.backgroundColor = UIColor.black
        self.proportionDistortionLabel.textColor = UIColor.red
        self.groupsTableView.backgroundColor = UIColor.black
        self.groupsTableView.separatorColor = UIColor.blue
        self.addRecipeButton.backgroundColor = UIColor.blue
        self.addRecipeButton.tintColor = UIColor.black
        self.addGroupButton.backgroundColor = UIColor.blue
        self.addGroupButton.tintColor = UIColor.black
        
        self.proportionDistortionLabel.font = UIFont(name: "MarkerFelt-Thin", size: 36.0)
        
        if let savedRecipes = loadRecipes() {
            print("loading recipes")
            recipeList.allRecipes = savedRecipes
        } else {
            loadSampleGroupRecipes()
        }

        if let savedGroups = loadGroups() {
            print("loading groups")
            groups = savedGroups
        } else {
            loadSampleGroups()
        }
        
        
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
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor.black
        searchBar.barTintColor = UIColor.black
        searchBar.layer.borderColor = UIColor.blue.cgColor
        searchBar.layer.borderWidth = 6
        
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
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor.black
        searchBar.barTintColor = UIColor.black
        searchBar.layer.borderColor = UIColor.blue.cgColor
        searchBar.layer.borderWidth = 1
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
                cellTitles.append(g)
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.black
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.blue
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
            var recipes = [Recipe]()
            
            showGroupViewController.recipeList = self.recipeList
            
            for r in recipeList.allRecipes{
                if r.recipeGroup == selectedGroup {
                    recipes += [r]
                }
            }
            showGroupViewController.recipes = recipes

            showGroupViewController.navigationItem.title = selectedGroup
            
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
            let newGroupName = sourceViewController.newGroupName
            self.groups.append(newGroupName!)
            groupsTableView.reloadData()
            saveGroups()
        }
        if let sourceViewController = sender.source as? ShowRecipeViewController {
            recipeList.allRecipes = (sourceViewController.recipeList?.allRecipes)!
            
            
        
            saveRecipes()
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
    
    private func loadSampleGroups() {
        let group1 = "Soups"
        let group2 = "Chicken"
        let group3 = "Mexican"
        
        groups += [group1,group2,group3]
    }
    
    private func loadSampleGroupRecipes() {
        print("loading sample recipes")
        let ingredients = [Ingredient]()
        let steps = [Step]()
        
        let recipe1 = Recipe(recipeName: "Butternut Squash", recipeIngredients: ingredients , recipeSteps: steps, recipeGroup: "Soups")
        let recipe2 = Recipe(recipeName: "Seseme Ginger Chicken", recipeIngredients: ingredients, recipeSteps: steps, recipeGroup: "Chicken")
        let recipe3 = Recipe(recipeName: "Steak Tacos", recipeIngredients: ingredients, recipeSteps: steps, recipeGroup: "Mexican")

        recipeList.allRecipes += [recipe1]
        recipeList.allRecipes += [recipe2]
        recipeList.allRecipes += [recipe3]
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
    
    func saveGroups() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(groups, toFile: Group.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Groups successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save groups...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadGroups() -> [String]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Group.ArchiveURL.path) as? [String]
    }

}
