//
//  StepsTableViewController.swift
//  ProportionDistortion
//
//  Created by Dingy Pumba on 3/18/17.
//  Copyright © 2017 Nick Snyder. All rights reserved.
//

import UIKit
import os.log

class StepsTableViewController: UITableViewController {
    
    
//MARK: Properties
    var steps = [Step]()
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        
        //Automatically adjust cells to fit textview size
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        
        loadAddCell()
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
        return steps.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stepCellIdentifier = "StepsTableViewCell"
        let addStepCellIdentifier = "AddNewStepTableViewCell"
        
        let currentCellIndex = indexPath.row
        
        if currentCellIndex < steps.count-1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: stepCellIdentifier, for: indexPath) as? StepsTableViewCell else {
                fatalError("Cell is not of type StepsTableViewCell")
            }
            
            let step = steps[indexPath.row]
            // Configure the cell...
            
            cell.step.text = "Step \(indexPath.row + 1): " + step.step
            cell.step.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
            
            cell.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: addStepCellIdentifier, for: indexPath) as? AddStepsTableViewCell else {
                fatalError("Cell is not of type AddStepsTableViewCell")
            }
            
            let step = steps[indexPath.row]
            // Configure the cell...
            
            cell.step.text = step.step
            cell.step.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
            cell.step.textColor = UIColor.gray
            
            cell.backgroundColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)
            
            return cell
        }
        
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.row == steps.count-1 {
            return false
        } else {
            return true
        }
    }
    

    
// Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            steps.remove(at: indexPath.row)
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


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let button = sender as? UIBarButtonItem, button === saveButton {
            return
        }
        
        switch (segue.identifier ?? "") {
            
        case "AddStep":
            os_log("Adding new step", log: OSLog.default, type: .debug)
            
        case "EditStep":
            guard let addStepViewController = segue.destination as? AddStepsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedStepCell = sender as? StepsTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedStepCell) else {
                fatalError("Selected cell not displayed in table")
            }
            
            let selectedStep = steps[indexPath.row]
            
            addStepViewController.step = selectedStep
            
        default:
            fatalError("Unexpected Segue identifier: \(String(describing: segue.identifier))")
        }
        
    }
    
    @IBAction func cancelAddSteps(_ sender: UIBarButtonItem) {
        if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }

    }
    
    
    
    
    
//MARK: Actions
    @IBAction func unwindToStepsList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddStepsViewController, let step = sourceViewController.step {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                if steps[selectedIndexPath.row].step != "Add New Step" {
                    steps[selectedIndexPath.row] = step
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                } else {
                    let newIndexPath = IndexPath(row: steps.count-1, section: 0)
                    
                    steps.insert(step, at: steps.count-1)
                    
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            }
        }
    }

    
//MARK: Helper Methods
    
    func loadAddCell() {
        let addNewStepText = "Add New Step"
        
        guard let newStepButtonCell = Step(step: addNewStepText) else {
            fatalError("Could not create Add New Step cell")
        }
        
        if steps.last?.step != addNewStepText {
            steps += [newStepButtonCell]
        }
    }
}
