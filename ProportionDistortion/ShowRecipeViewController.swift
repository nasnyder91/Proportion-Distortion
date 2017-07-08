//
//  ShowRecipeViewController.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/21/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.


import UIKit
import os.log


class ShowRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
//MARK: Properties
    @IBOutlet weak var recipeTableView: UITableView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var distortButton: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var editGroupButton: UIButton!
    @IBOutlet weak var groupStackView: UIStackView!
    
    var allGroups = [String]()
    
    var editGroupPickerView = UIPickerView()
    var groupChoices = [String]()
    
    var distortPickerView = UIPickerView()
    let distortChoices: [Double] = [0.25, 0.5, 1, 1.5, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var distortValue: Double?
    var distortedIngredients = [Ingredient]()
    var recipe: Recipe?
    var recipeList: AllRecipes?
    
    var cameFromAdd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        groupNameLabel.text = "Group: \(self.recipe?.recipeGroup ?? "")"
        groupNameLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 22)
        editGroupButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 22)
        editGroupButton.tintColor = UIColor.gray
        
        
        self.view.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.recipeTableView.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.recipeTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.recipeTableView.separatorColor = UIColor(red: 225.0/255.0, green: 60.0/255.0, blue: 0/255.0, alpha: 0.5)
        self.recipeTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.recipeTableView.layer.borderWidth = 1
        self.recipeTableView.layer.borderColor = UIColor.black.cgColor
        
        self.distortButton.tintColor = UIColor(red: 225.0/255.0, green: 60.0/255.0, blue: 0/255.0, alpha: 1.0)
        self.distortButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 48)
        
        self.distortPickerView.tintColor = UIColor.black
        
        //Table View delegation and data source
        self.recipeTableView.delegate = self
        self.recipeTableView.dataSource = self
        self.recipeTableView.separatorColor = UIColor.black
        
        //Picker view delegation and data source
        self.distortPickerView.delegate = self
        self.distortPickerView.dataSource = self
        self.distortPickerView.showsSelectionIndicator = true
        self.distortPickerView.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        
        self.distortPickerView.isHidden = true
        self.distortPickerView.isOpaque = true
        self.view.addSubview(distortPickerView)
        self.distortPickerView.translatesAutoresizingMaskIntoConstraints = false
        self.distortPickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.distortPickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.distortPickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.distortPickerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4, constant: 0.0)
        self.distortPickerView.selectRow(2, inComponent: 0, animated: false)
        
        groupChoices = allGroups
        if groupChoices.contains("All Recipes") {
            let allIndex = groupChoices.index(of: "All Recipes")
            groupChoices.remove(at: allIndex!)
        }
        
        
        self.editGroupPickerView.delegate = self
        self.editGroupPickerView.dataSource = self
        self.editGroupPickerView.showsSelectionIndicator = true
        self.editGroupPickerView.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.editGroupPickerView.isHidden = true
        self.editGroupPickerView.isOpaque = true
        self.view.addSubview(editGroupPickerView)
        self.editGroupPickerView.translatesAutoresizingMaskIntoConstraints = false
        self.editGroupPickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.editGroupPickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.editGroupPickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.editGroupPickerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4, constant: 0.0)
        self.editGroupPickerView.selectRow(2, inComponent: 0, animated: false)
        
        let tapOutsidePicker = UITapGestureRecognizer(target: self, action: #selector(cancelPicker(sender:)))
        self.view.addGestureRecognizer(tapOutsidePicker)
        
        
        autoSizeCells()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func autoSizeCells() {
        //Automatically adjust cells to fit textview size
        self.recipeTableView.estimatedRowHeight = 100
        self.recipeTableView.rowHeight = UITableViewAutomaticDimension
        self.recipeTableView.setNeedsLayout()
        self.recipeTableView.layoutIfNeeded()
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ingredientsIdentifier, for: indexPath) as? ShowIngredientsTableViewCell else {
                fatalError("Cell is not of type ShowIngredientsTableViewCell")
            }
            var ingredientsText = ""
            
            let ingredientsList = (self.recipe?.recipeIngredients)!
                for i in 0..<ingredientsList.count {
                    let ingredient = ingredientsList[i]
                    let distortedIngredient = distortedIngredients[i]
                    print(convertQuantityToDecimal(ingredient: ingredient))
                    
                    
                    if distortedIngredient.quantity == ingredient.quantity && !unitIsMetric(unit: ingredient.unit) {
                        
                        ingredient.quantity = convertQuantityToDecimal(ingredient: ingredient)
                        ingredient.quantity = convertQuantityToFraction(quantity: ingredient.quantity)
                        
                        
                        if i < ingredientsList.count-1 {
                            ingredientsText += "\u{2022} \(ingredient.quantity) \(ingredient.unit) \(ingredient.ingredient)\n"
                        } else {
                            ingredientsText += "\u{2022} \(ingredient.quantity) \(ingredient.unit) \(ingredient.ingredient)"
                        }
                    } else if distortedIngredient.quantity == ingredient.quantity && unitIsMetric(unit: ingredient.unit) {
                        
                        ingredient.quantity = convertQuantityToDecimal(ingredient: ingredient)
                        
                        if i < ingredientsList.count-1 {
                            ingredientsText += "\u{2022} \(ingredient.quantity) \(ingredient.unit) \(ingredient.ingredient)\n"
                        } else {
                            ingredientsText += "\u{2022} \(ingredient.quantity) \(ingredient.unit) \(ingredient.ingredient)"
                        }
                    } else if !unitIsMetric(unit: ingredient.unit){
                        
                        distortedIngredient.quantity = convertQuantityToDecimal(ingredient: distortedIngredient)
                        distortedIngredient.quantity = convertQuantityToFraction(quantity: distortedIngredient.quantity)
                        
                        if i < ingredientsList.count-1 {
                            ingredientsText += "\u{2022} \(distortedIngredient.quantity) \(distortedIngredient.unit) \(distortedIngredient.ingredient)\n"
                        } else {
                            ingredientsText += "\u{2022} \(distortedIngredient.quantity) \(distortedIngredient.unit) \(distortedIngredient.ingredient)"
                        }
                    } else if unitIsMetric(unit: ingredient.unit) {
                        
                        distortedIngredient.quantity = convertQuantityToDecimal(ingredient: distortedIngredient)
                        
                        if i < ingredientsList.count-1 {
                            ingredientsText += "\u{2022} \(distortedIngredient.quantity) \(distortedIngredient.unit) \(distortedIngredient.ingredient)\n"
                        } else {
                            ingredientsText += "\u{2022} \(distortedIngredient.quantity) \(distortedIngredient.unit) \(distortedIngredient.ingredient)"
                        }
                    }
                
            }
            
            cell.ingredientsTextView.text = ingredientsText
            
            cell.ingredientsTextView.font = UIFont(name: "ChalkboardSE-Regular", size: 22)
            let screenSize = UIScreen.main.bounds
            let size = CGSize(width: screenSize.width, height: screenSize.height)
            cell.ingredientsTextView.sizeThatFits(size)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none

            cell.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)

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
            
            cell.stepsTextView.font = UIFont(name: "ChalkboardSE-Regular", size: 22)
            //let screenSize = UIScreen.main.bounds
            //let size = CGSize(width: screenSize.width, height: screenSize.height)
            //cell.stepsTextView.sizeThatFits(size)
            //cell.stepsTextView.sizeToFit()
            cell.sizeToFit()
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
            
            
            
            return cell
            
        default:
            fatalError("Could not create cell")
        }
     }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
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

//MARK: Picker View Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == distortPickerView {
            return distortChoices.count
        } else {
            return groupChoices.count
        }
    }
    
    /*func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var distortChoiceString: String
        if distortChoices[row] < 1 || String(distortChoices[row]).contains(".5") {
            distortChoiceString = String(distortChoices[row]) + "x"
        }
        else {
            distortChoiceString = String(Int(distortChoices[row])) + "x"
        }
        return distortChoiceString
    }*/
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == distortPickerView {
            distortValue = distortChoices[row]
            pickerView.isHidden = true
            distortIngredientsList()
            let newIndexPath = IndexPath(row: 0, section: 0)
            self.recipeTableView.reloadRows(at: [newIndexPath], with: .none)
            autoSizeCells()
        } else {
            let newGroup = groupChoices[row]
            pickerView.isHidden = true
            let recipeName = recipe?.recipeName
            for r in (recipeList?.allRecipes)! {
                if r.recipeName == recipeName {
                    r.recipeGroup = newGroup
                }
            }
            groupNameLabel.text = "Group: \(newGroup)"
        }
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == distortPickerView {
            var distortChoiceString: String
            if distortChoices[row] < 1 || String(distortChoices[row]).contains(".5") {
                distortChoiceString = String(distortChoices[row]) + "x"
            }
            else {
                distortChoiceString = String(Int(distortChoices[row])) + "x"
            }
            let myTitle = NSAttributedString(string: String(distortChoiceString), attributes: [NSFontAttributeName:UIFont(name: "ChalkboardSE-Regular", size: 15.0)!,NSForegroundColorAttributeName:UIColor(red: 29.0/255.0, green: 55.0/255.0, blue: 3.0/255.0, alpha: 1.0)])
            return myTitle
        } else {
            let groupString = groupChoices[row]
            let myTitle = NSAttributedString(string: String(groupString), attributes: [NSFontAttributeName:UIFont(name: "ChalkboardSE-Regular", size: 15.0)!,NSForegroundColorAttributeName:UIColor(red: 29.0/255.0, green: 55.0/255.0, blue: 3.0/255.0, alpha: 1.0)])
            return myTitle
        }
        
    }
    
    func cancelPicker(sender: UIBarButtonItem) {
        print("Cancelling pciker")
        distortPickerView.resignFirstResponder()
        distortPickerView.isHidden = true
        editGroupPickerView.resignFirstResponder()
        editGroupPickerView.isHidden = true
    }
    
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
        
        case "":
           os_log("Going home", log: OSLog.default, type: .debug)
            
        default:
            fatalError("Unexpected segue identifier: \(String(describing: segue.identifier))")
        }
        
    }
    
//MARK: Actions
    @IBAction func unwindToRecipe(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? IngredientsTableViewController {
            var ingredients = sourceViewController.ingredients
            
            ingredients.remove(at: ingredients.count-1)
            
            self.recipe?.recipeIngredients = ingredients
            self.distortedIngredients = ingredients
            //self.recipeList?.addRecipe(recipe: self.recipe!)
            
            recipeTableView.reloadData()
            //saveIngredients()
        }
        if let sourceViewController = sender.source as? StepsTableViewController {
            var steps = sourceViewController.steps
            
            steps.remove(at: steps.count-1)
            
            recipe?.recipeSteps = steps
            
            recipeTableView.reloadData()
            //saveSteps()
        }
    }

    @IBAction func showDistortPickerView(_ sender: UIButton) {
        distortPickerView.isHidden = false
        editGroupPickerView.isHidden = true
    }
    
    @IBAction func showEditGroup(_ sender: UIButton) {
        editGroupPickerView.isHidden = false
        distortPickerView.isHidden = true
    }
    
    
//MARK: Instance Methods
    func unitIsMetric(unit: String) -> Bool {
        if unit == "g" || unit == "ml" {
            return true
        } else {
            return false
        }
    }
    
    func distortIngredientsList() {
        let ingredientsList = (recipe?.recipeIngredients)!
        
        for i in 0..<ingredientsList.count {
            let ingredient = ingredientsList[i]
            
            let decimalIngredientQuantity = convertQuantityToDecimal(ingredient: ingredient)

            if let initialQuantity = Double(decimalIngredientQuantity)  {
                let newIngredient = Ingredient(quantity: String(initialQuantity * distortValue!), unit: ingredientsList[i].unit, ingredient: ingredientsList[i].ingredient)
                print("new ingredient: " + newIngredient.quantity)
                distortedIngredients[i] = newIngredient
            } else {
                let newIngredient = Ingredient(quantity: "", unit: ingredientsList[i].unit, ingredient: ingredientsList[i].ingredient)
                distortedIngredients[i] = newIngredient
            }
        }
    }
    
    func convertQuantityToDecimal(ingredient: Ingredient) -> String{
        let quantity = ingredient.quantity
        var convertedQuantity: String
        
        if !quantity.isEmpty && quantity.contains("/") {
            
            let slashIndex = quantity.range(of: "/")?.lowerBound
            
            let beforeSlash = quantity.substring(to: slashIndex!)
            
            var afterSlash = quantity.substring(from: slashIndex!)
            afterSlash.remove(at: afterSlash.startIndex)
            
            if quantity.contains(" ") {
                let spaceIndex = quantity.range(of: " ")?.lowerBound
                
                let wholeNumber = quantity.substring(to: spaceIndex!)
                
                var beforeSlashAfterSpace = beforeSlash
                beforeSlashAfterSpace = beforeSlashAfterSpace.substring(from: (beforeSlashAfterSpace.range(of: " ")?.lowerBound)!)
                beforeSlashAfterSpace.remove(at: beforeSlashAfterSpace.startIndex)
                
                let doublizedWhole = Double(wholeNumber)
                let doublizedFirst = Double(beforeSlashAfterSpace)
                let doublizedLast = Double(afterSlash)
                
                convertedQuantity = String((doublizedFirst! / doublizedLast!) + doublizedWhole!)
                
                return convertedQuantity
            }
            
            let doublizedFirst = Double(beforeSlash)
            let doublizedLast = Double(afterSlash)

            convertedQuantity = String(doublizedFirst! / doublizedLast!)
                
            return convertedQuantity
            
        }
        return quantity
    }
    
    func convertQuantityToFraction(quantity: String) -> String {
        var fractionizedQuantity: String
        var finalQuantity: String
        var wholeNumber: String
        
        if !quantity.contains(".") {
            return quantity
        }
        
        let decimalIndex = quantity.range(of: ".")?.lowerBound
        
        var numerator = quantity.substring(from: decimalIndex!)
        numerator.remove(at: numerator.startIndex)
        
        if Int(numerator) == 0 {
            return quantity.substring(to: decimalIndex!)
        }
        
        if Int(quantity.substring(to: decimalIndex!)) != 0 {
            wholeNumber = quantity.substring(to: decimalIndex!)
        } else{
            wholeNumber = ""
        }
        
        let decimalSize = numerator.characters.count
        
        var denominator = "1"
        
        for _ in 0..<decimalSize {
            denominator += "0"
        }
        
        fractionizedQuantity = numerator + "/" + denominator
        
        fractionizedQuantity = reduceStringFraction(fraction: fractionizedQuantity)
        
        if !wholeNumber.isEmpty {
            finalQuantity = wholeNumber + " " + fractionizedQuantity
        } else{
            finalQuantity = fractionizedQuantity
        }
        
        return finalQuantity
    }
    
    func reduceStringFraction(fraction: String) -> String{
        print(fraction)
        
        let fractions: [Double] = [15/16, 7/8, 13/16, 3/4, 11/16, 2/3, 5/8, 9/16, 1/2, 7/16, 3/8, 1/3, 5/16, 1/4, 3/16, 1/8, 1/16, 0]
        let stringFractions: [String] = ["15/16", "7/8", "13/16", "3/4", "11/16", "2/3", "5/8", "9/16", "1/2", "7/16", "3/8", "1/3", "5/16", "1/4", "3/16", "1/8", "1/16", "0"]
        
        
        let slashIndex = fraction.range(of: "/")?.lowerBound
        let numerator = fraction.substring(to: slashIndex!)
        var denominator = fraction.substring(from: slashIndex!)
        denominator.remove(at: denominator.startIndex)
        
        
        let decimal = Double(numerator)! / Double(denominator)!
        
        
        for i in 0..<fractions.count {
            if decimal <= fractions[i] && decimal > fractions[i + 1]  {
                if fractions[i + 1] == 0 {
                    return stringFractions[i]
                }
                let first = fractions[i] - decimal
                let second = decimal - fractions[i + 1]
                if first < second {
                    return stringFractions[i]
                } else {
                    return stringFractions[i + 1]
                }
            }
        }
        
        return stringFractions[0]
    }
}
