//
//  CategoriesFiltersViewController.swift
//  Yelp
//
//  Created by Michael Bock on 2/12/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol CategoriesFiltersViewControllerDelegate {
    optional func categoriesFiltersViewController(categoriesFiltersViewController: CategoriesFiltersViewController, didUpdateFilters categories: [String])
}

class CategoriesFiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: CategoriesFiltersViewControllerDelegate?

    var searchSettings: SearchSettings?

    var categoriesList: [[String: String]]!
    var switchStates = [Int: Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        categoriesList = yelpCategories()

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Update switch states to current values.
        switchStates = [Int: Bool]()
        if let searchSettingsCategory = searchSettings?.categories {
            for selectedCategory in searchSettingsCategory {
                switchStates[indexForCategoryCode(selectedCategory)] = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onDoneButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)

        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categoriesList[row]["code"]!)
            }
        }

        delegate?.categoriesFiltersViewController?(self, didUpdateFilters: selectedCategories)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchTableViewCell", forIndexPath: indexPath) as! SwitchTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.switchLabel.text = categoriesList[indexPath.row]["name"]
        cell.delegate = self
        cell.onSwitch.on = switchStates[indexPath.row] ?? false

        return cell
    }

    func switchTableViewCell(switchTableViewCell: SwitchTableViewCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchTableViewCell)!
        switchStates[indexPath.row] = value
    }

    func yelpCategories() -> [[String:String]] {
        return [
            ["name": "American, New", "code": "newamerican"],
            ["name": "Italian", "code": "italian"],
            ["name": "French", "code": "french"],
            ["name": "German", "code": "german"],
            ["name": "Japanese", "code": "japanese"],
            ["name": "Mexican", "code": "mexican"],
            ["name": "Middle Eastern", "code": "mideastern"],
        ]
    }

    func indexForCategoryCode(code: String) -> Int {
        var returnIndex = -1
        for (index, categoryDict) in categoriesList.enumerate() {
            if categoryDict["code"] == code {
                returnIndex = index
            }
        }
        return returnIndex
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
