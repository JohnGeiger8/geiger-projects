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

        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
