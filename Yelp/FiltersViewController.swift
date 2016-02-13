//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Michael Bock on 2/12/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?

    var categories: [[String: String]]!
    var switchStates = [Int: Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        categories = yelpCategories()

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearchButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)

        var filters = [String: AnyObject]()

        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }

        delegate?.filtersViewController?(self, didUpdateFilters: filters )
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchTableViewCell", forIndexPath: indexPath) as! SwitchTableViewCell

        cell.switchLabel.text = categories[indexPath.row]["name"]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
