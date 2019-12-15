//
//  OutfitItemTableViewCell.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 12/14/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class OutfitItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
