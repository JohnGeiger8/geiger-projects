//
//  OutfitNameTableViewCell.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 12/14/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class OutfitNameTableViewCell: UITableViewCell {

    @IBOutlet weak var outfitNameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
