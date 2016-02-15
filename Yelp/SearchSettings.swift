//
//  SearchSettings.swift
//  Yelp
//
//  Created by Michael Bock on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

struct SearchSettings {
    var searchString: String?
    var deals: Bool?
    var distance: YelpDistance?
    var sortBy: YelpSortMode?
    var categories: [String]?

    init() {
    }
}
