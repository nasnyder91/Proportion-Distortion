//
//  ShowRecipeViewController.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/21/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit
import os.log


class ShowRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
//MARK: Properties
    @IBOutlet weak var recipeTableView: UITableView!
    
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
        
        /*
        if let savedIngredients = loadIngredients() {
            recipe?.recipeIngredients = savedIngredients
        }
        
        if let savedSteps = loadSteps() {
            recipe?.recipeSteps = savedSteps
        }*/
        //Table View delegation and data source
        self.recipeTableView.delegate = self
        self.recipeTableView.dataSource = self
        
        //Picker view delegation and data source
        self.distortPickerView.delegate = self
        self.distortPickerView.dataSource = self
        self.distortPickerView.backgroundColor = UIColor.white
        self.distortPickerView.isHidden = true
        self.distortPickerView.isOpaque = true
        self.view.addSubview(distortPickerView)
        self.distortPickerView.translatesAutoresizingMaskIntoConstraints = false
        self.distortPickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.distortPickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.distortPickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.distortPickerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4, constant: 0.0)
        self.distortPickerView.selectRow(2, inComponent: 0, animated: false)
        
        
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
                    } else if !unitIsMetric(unit: ingredient.unit){
                        distortedIngredient.quantity = convertQuantityToDecimal(ingredient: distortedIngredient)
                        distortedIngredient.quantity = convertQuantityToFraction(quantity: distortedIngredient.quantity)
                        
                        if i < ingredientsList.count-1 {
                            ingredientsText += "\u{2022} \(distortedIngredient.quantity) \(distortedIngredient.unit) \(distortedIngredient.ingredient)\n"
                        } else {
                            ingredientsText += "\u{2022} \(distortedIngredient.quantity) \(distortedIngredient.unit) \(distortedIngredient.ingredient)"
                        }
                    } else if unitIsMetric(unit: ingredient.unit){
                        if i < ingredientsList.count-1 {
                            ingredientsText += "\u{2022} \(distortedIngredient.quantity) \(distortedIngredient.unit) \(distortedIngredient.ingredient)\n"
                        } else {
                            ingredientsText += "\u{2022} \(distortedIngredient.quantity) \(distortedIngredient.unit) \(distortedIngredient.ingredient)"
                        }
                    }
                
            }
            
            cell.ingredientsTextView.text = ingredientsText
            cell.ingredientsTextView.sizeToFit()
            cell.selectionStyle = UITableViewCellSelectionStyle.none

            
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
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
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

//MARK: Picker View Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return distortChoices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var distortChoiceString: String
        if distortChoices[row] < 1 || String(distortChoices[row]).contains(".5") {
            distortChoiceString = String(distortChoices[row])
        }
        else {
            distortChoiceString = String(Int(distortChoices[row]))
        }
        return distortChoiceString + "X"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        distortValue = distortChoices[row]
        pickerView.isHidden = true
        distortIngredientsList()
        let newIndexPath = IndexPath(row: 0, section: 0)
        self.recipeTableView.reloadRows(at: [newIndexPath], with: .none)
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
            fatalError("Unexpected segue identifier: \(segue.identifier)")
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
        let slashIndex = fraction.range(of: "/")?.lowerBound
        var numerator = fraction.substring(to: slashIndex!)
        var denominator = fraction.substring(from: slashIndex!)
        denominator.remove(at: denominator.startIndex)
        
        let intNumerator = Int(numerator)
        let intDenominator = Int(denominator)
        
        for i in 0..<intNumerator! {
            if (intNumerator! % (intNumerator! - i)) == 0 && (intDenominator! % (intNumerator! - i)) == 0 {
                if numerator != String(intNumerator! / (intNumerator! - i)) && denominator != String(intDenominator! / (intNumerator! - i)){
                    numerator = String(intNumerator! / (intNumerator! - i))
                    denominator = String(intDenominator! / (intNumerator! - i))
                } else {
                    return (numerator + "/" + denominator)
                }
                
                return reduceStringFraction(fraction: (numerator + "/" + denominator))
            }
        }
        return (numerator + "/" + denominator)
    }
    /*
    func saveIngredients() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(recipe?.recipeIngredients as Any, toFile: Ingredient.ArchiveURL.path)
        print("Saved ingredients")
        if isSuccessfulSave {
            os_log("Ingredients successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Ingredients...", log: OSLog.default, type: .error)
        }
    }
    private func loadIngredients() -> [Ingredient]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Ingredient.ArchiveURL.path) as? [Ingredient]
    }
    
    func saveSteps() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(recipe?.recipeSteps as Any, toFile: Step.ArchiveURL.path)
        print("Saved Steps")
        if isSuccessfulSave {
            os_log("Steps successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save steps...", log: OSLog.default, type: .error)
        }
    }
    private func loadSteps() -> [Step]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Step.ArchiveURL.path) as? [Step]
    }*/
}
