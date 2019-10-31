//
//  ClothingTableViewCell.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 10/30/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class ClothingTableViewCell: UITableViewCell {

    @IBOutlet weak var clothingImageView: UIImageView!
    @IBOutlet weak var clothingNameLabel: UILabel!
    @IBOutlet weak var clothingInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
