//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import MBProgressHUD
import UIKit

class BusinessesViewController: UIViewController {

    var businesses: [Business]!
    var searchSettings = SearchSettings()
    var newData = true

    var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        // Initialize the UISearchBar.
        searchBar = UISearchBar()
        searchBar.delegate = self
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }

    override func viewWillAppear(animated: Bool) {
        if newData {
            doSearch()
            newData = false
        }
    }

    func doSearch() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        let searchTerm = searchSettings.searchString ?? "Restaurants"

        Business.searchWithTerm(searchTerm, sort: searchSettings.sortBy, categories: searchSettings.categories, deals: searchSettings.deals) { (businesses: [Business]!, error: NSError!) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController

        filtersViewController.searchSettings = searchSettings
        filtersViewController.delegate = self
    }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateSearchSettings searchSettings: SearchSettings) {
        newData = true
        self.searchSettings = searchSettings
    }
}

extension BusinessesViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessTableViewCell", forIndexPath: indexPath) as! BusinessTableViewCell

        cell.business = businesses[indexPath.row]

        return cell
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }

    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()

        doSearch()
    }
}
