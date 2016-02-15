//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Michael Bock on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateSearchSettings searchSettings: SearchSettings)
}

struct sectionState {
    var header: String?
    var size: Int
    var cellTitles: [String]

    init(header: String?, size: Int, cellTitles: [String]) {
        self.header = header
        self.size = size
        self.cellTitles = cellTitles
    }
}

class FiltersViewController: UIViewController {

    var delegate: FiltersViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    var searchSettings: SearchSettings?
    var tableState: [sectionState]!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableState = [
            sectionState(header: nil, size: 1, cellTitles: ["Offering a Deal"]),
            sectionState(header: "Sort By", size: 5, cellTitles: ["1", "2", "3", "4", "5"]),
            sectionState(header: "Distance", size: 5, cellTitles: ["1", "2", "3", "4", "5"]),
            sectionState(header: "Categories", size: 1, cellTitles: ["View all"])
        ]

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    @IBAction func onCancelButton() {
        // Don't change searchSettings object.
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSaveButton() {
        dismissViewControllerAnimated(true, completion: nil)

        delegate?.filtersViewController(self, didUpdateSearchSettings: searchSettings!)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let categoriesFiltersViewController = navigationController.topViewController as! CategoriesFiltersViewController

        categoriesFiltersViewController.searchSettings = searchSettings
        categoriesFiltersViewController.delegate = self
    }
}

extension FiltersViewController: DealSwitchTableViewCellDelegate {
    func dealSwitchTableViewCell(dealSwitchTableViewCell: DealSwitchTableViewCell, didChangeValue value: Bool) {
        searchSettings?.deals = value
    }
}

extension FiltersViewController: CategoriesFiltersViewControllerDelegate {
    func categoriesFiltersViewController(categoriesFiltersViewController: CategoriesFiltersViewController, didUpdateFilters categories: [String]) {
        self.searchSettings?.categories = categories
    }
}

extension FiltersViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableState.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableState[section].header
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableState[section].size
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // cell.textLabel!.text = tableState[indexPath.section].cellTitles[indexPath.row]
        let cell: UITableViewCell?

        switch indexPath.section {
        case 0:  // Deal on/off.
            let dealSwitchCell = tableView.dequeueReusableCellWithIdentifier("DealSwitchTableViewCell", forIndexPath: indexPath) as! DealSwitchTableViewCell
            dealSwitchCell.delegate = self
            dealSwitchCell.onSwitch.on = searchSettings?.deals ?? false
            cell = dealSwitchCell
        default:
            cell = UITableViewCell()
            cell!.textLabel!.text = tableState[indexPath.section].cellTitles[indexPath.row]
        }

        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
