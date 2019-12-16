//
//  DatePickerViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 12/9/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit

protocol PurchaseDateDelegate : NSObject {
    func choosePurchaseDate(_ date: Date)
}

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate : PurchaseDateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func chooseDate(_ sender: Any) {
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
        delegate?.choosePurchaseDate(datePicker.date)
    }

}
