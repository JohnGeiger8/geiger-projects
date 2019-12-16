//
//  ClothingTableViewCell.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 10/30/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class ClothingTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemInfoLabel: UILabel!
    @IBOutlet var itemLoanedButton: UIButton!
    @IBOutlet weak var brandNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
