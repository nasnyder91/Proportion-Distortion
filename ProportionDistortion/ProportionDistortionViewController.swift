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
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var proportionMeetsDistortionLabel: UILabel!
    
    
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
        
        self.view.isOpaque = false
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 225.0/255.0, green: 60.0/255.0, blue: 0/255.0, alpha: 1.0), NSFontAttributeName: UIFont(name: "ChalkboardSE-Regular", size: 22)!]
        self.navigationController?.navigationBar.tintColor = UIColor(red: 29.0/255.0, green: 55.0/255.0, blue: 3.0/255.0, alpha: 1.0)

        
        self.view.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        
        self.proportionDistortionLabel.textColor = UIColor(red: 225.0/255.0, green: 60.0/255.0, blue: 0/255.0, alpha: 1.0)
        self.proportionDistortionLabel.font = UIFont(name: "MarkerFelt-Thin", size: 40.0)
        self.proportionMeetsDistortionLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        self.proportionMeetsDistortionLabel.font = UIFont(name: "MarkerFelt-Thin", size: 15.0)
        
        self.groupsTableView.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.groupsTableView.separatorColor = UIColor(red: 225.0/255.0, green: 60.0/255.0, blue: 0/255.0, alpha: 0.5)
        
        self.addRecipeButton.backgroundColor = UIColor(red: 225.0/255.0, green: 60.0/255.0, blue: 0/255.0, alpha: 0.5)
        self.addRecipeButton.tintColor = UIColor.black
        self.addRecipeButton.titleLabel!.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        self.addGroupButton.backgroundColor = UIColor(red: 225.0/255.0, green: 60.0/255.0, blue: 0/255.0, alpha: 0.5)
        self.addGroupButton.tintColor = UIColor.black
        self.addGroupButton.titleLabel!.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        
        self.searchResultsTable.tableView.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.searchResultsTable.tableView.separatorColor = UIColor(red: 225.0/255.0, green: 60.0/255.0, blue: 0/255.0, alpha: 0.5)
        
        
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
        
        layoutSubview()
    
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
        textFieldInsideSearchBar?.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        textFieldInsideSearchBar?.font = UIFont(name: "ChalkboardSE-Regular", size: 20.0)
        searchBar.barTintColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        searchBar.layer.borderColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        searchBar.layer.borderWidth = 10
        self.view.addSubview(searchBar)
        
        let searchBarLocation = titleStackView.frame.origin.y + titleStackView.frame.size.height + 17
        searchBar.frame.origin.y = searchBarLocation
        
        let searchBarBottomAnchor = searchBar.bottomAnchor
        
        groupsTableView.topAnchor.constraint(equalTo: searchBarBottomAnchor, constant: -27.0).isActive = true
        
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
        
        cell?.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.resultsSearchController.isActive {
            performSegue(withIdentifier: "ShowSearchedRecipe", sender: searchResultsTable.tableView.cellForRow(at: indexPath))
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //if self.resultsSearchController.isActive {
        //    return 0
        //}
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your Recipe Groups"
    }*/
    /*
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 231.0/255.0, green: 250.0/255.0, blue: 133.0/255.0, alpha: 1.0)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.blue
        header.textLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 16.0)
    }*/
    
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if !(resultsSearchController.isActive) {
            if indexPath.row == 0 {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
 
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if !(resultsSearchController.isActive) {
            if editingStyle == .delete {
                // Delete the row from the data source
                groups.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                saveGroups()
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
        
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
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = groupsTableView.indexPath(for: selectedGroupNameCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedGroup = groups[indexPath.row]
            var recipes = [Recipe]()
            
            showGroupViewController.recipeList = self.recipeList
            if selectedGroup == "All Recipes" {
                recipes = self.recipeList.allRecipes
            } else {
                for r in recipeList.allRecipes{
                    if r.recipeGroup == selectedGroup {
                        recipes += [r]
                    }
                }
            }
            
            showGroupViewController.recipes = recipes
            showGroupViewController.groupsList = groups

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
            fatalError("Unexpected segue identifier: \(String(describing: segue.identifier))")
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
        titleStackView.isHidden = true
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        print("Dismissed")
        self.navigationController?.navigationBar.isTranslucent = false
        self.layoutSubview()
        titleStackView.isHidden = false
    }
    
//MARK: Private Methods
    
    private func loadSampleGroups() {
        let allRecipesGroup = "All Recipes"
        let group1 = "Pasta"
        let group2 = "Salads"
        let group3 = "Desserts"
        
        groups += [allRecipesGroup,group1,group2,group3]
    }
    
    private func loadSampleGroupRecipes() {
        print("loading sample recipes")
        
        var macIngredients = [Ingredient]()
        var macSteps = [Step?]()
        
        macIngredients += [Ingredient(quantity: "1", unit: "Cup", ingredient: "whole-wheat macaroni"), Ingredient(quantity: "2", unit: "Tbsp", ingredient: "butter"), Ingredient(quantity: "2", unit: "Tbsp", ingredient: "whole-wheat flour"), Ingredient(quantity: "1", unit: "Cup", ingredient: "milk"), Ingredient(quantity: "1", unit: "Cup", ingredient: "grated cheddar cheese"), Ingredient(quantity: "", unit: "Dash", ingredient: "Salt"), Ingredient(quantity: "", unit: "Dash", ingredient: "Pepper")]
        
        macSteps += [Step(step: "Cook macaroni according to package directions."), Step(step: "Melt the butter in a pan over medium heat."), Step(step: "Whisk in the flour and keep whisking for 1-2 minutes"), Step(step: "Turn heat down to low.  Whisk in milk.  Turn heat back up to medium and keep whisking until all lumps of flour are dissolved and sauce thickens."), Step(step: "Stir in grated cheese.  Mix in cooked noodles.  Season with salt and pepper.")]
        
        let recipe1 = Recipe(recipeName: "Whole Wheat Mac n Cheese", recipeIngredients: macIngredients , recipeSteps: macSteps as! [Step], recipeGroup: "Pasta")
        
        var salIngredients = [Ingredient]()
        var salSteps = [Step?]()
        
        salIngredients += [Ingredient(quantity: "2/3", unit: "Cup", ingredient: "slivered toasted almonds"), Ingredient(quantity: "3", unit: "Cup", ingredient: "chopped cooked chicken"), Ingredient(quantity: "3/4", unit: "Cup", ingredient: "dried cranberries"), Ingredient(quantity: "2", unit: "", ingredient: "diced celery ribs"), Ingredient(quantity: "1/2", unit: "", ingredient: "diced small sweet onion"), Ingredient(quantity: "3/4", unit: "Cup", ingredient: "mayonnaise"), Ingredient(quantity: "2", unit: "Tbsp", ingredient: "fresh lemon juice")]
        
        salSteps += [Step(step: "Stir together almonds, chicken, dried cranberries, onion, and celery ribs."), Step(step: "Stir in mayo and fresh lemon juice."), Step(step: "(optional) add black pepper, salt, or your choice of seasoning for taste.")]
        let recipe2 = Recipe(recipeName: "Cranberry-Almond Chicken Salad", recipeIngredients: salIngredients, recipeSteps: salSteps as! [Step], recipeGroup: "Salads")
        
        var desIngredients = [Ingredient]()
        var desSteps = [Step?]()
        
        desIngredients += [Ingredient(quantity: "6", unit: "Tbsp", ingredient: "cocunut oil or butter"), Ingredient(quantity: "6", unit: "oz", ingredient: "semi-sweet chocolate chips"), Ingredient(quantity: "2", unit: "", ingredient: "large eggs"), Ingredient(quantity: "2/3", unit: "Cup", ingredient: "sugar"), Ingredient(quantity: "2", unit: "Tsp", ingredient: "vanilla extract"), Ingredient(quantity: "1/4", unit: "Cup", ingredient: "unsweetened cocoa powder"), Ingredient(quantity: "3", unit: "Tbsp", ingredient: "arrowroot powder or corn starch"), Ingredient(quantity: "1/4", unit: "Tsp", ingredient: "salt")]
        
        desSteps += [Step(step: "Preheat oven to 350F"), Step(step: "Prepare 8x8 baking pan by lining it with a sheet of aluminum foil.  Grease the foil and set aside."), Step(step: "In a small sauce pan over low heat, mix coconut oil and chocolate chips.  Stir until combined.  Set aside to cool slightly."), Step(step: "Using a mixer, beat together eggs, sugar, and vanilla extract for about 2 minutes.  Mix in melted chocolate mixture."), Step(step: "Add the rest of ingredients.  Mix until smooth."), Step(step: "Pour batter into prepared pan."), Step(step: "Bake for 25-30 minutes."), Step(step: "Remove from oven and let cool for about 15 minutes."), Step(step: "Transfer brownies to a wire rack to cool completely.")]
        
        let recipe3 = Recipe(recipeName: "Flourless Chocolate Brownies", recipeIngredients: desIngredients, recipeSteps: desSteps as! [Step], recipeGroup: "Desserts")

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
