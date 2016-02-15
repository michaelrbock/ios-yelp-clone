//
//  DealSwitchTableViewCell.swift
//  Yelp
//
//  Created by Michael Bock on 2/14/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DealSwitchTableViewCellDelegate {
    optional func dealSwitchTableViewCell(dealSwitchTableViewCell: DealSwitchTableViewCell, didChangeValue value: Bool)
}

class DealSwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var onSwitch: UISwitch!

    weak var delegate: DealSwitchTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        onSwitch.addTarget(self, action: "switchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    }

    func switchValueChanged() {
        delegate?.dealSwitchTableViewCell?(self, didChangeValue: onSwitch.on)
    }
}
