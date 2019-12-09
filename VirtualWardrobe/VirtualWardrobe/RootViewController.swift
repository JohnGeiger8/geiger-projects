//
//  RootViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 11/13/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK:- Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ToWardrobe":
            break
        case "ToTrends":
            break
        default:
            assert(false, "Unhandled segue")
        }
    }

}
