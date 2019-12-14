//
//  AddItemViewController.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 11/14/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import UIKit
import MapKit

protocol AddItemDelegate : NSObject {
    func addNewItem(_ item: WardrobeItem)
    func updateItem(_ item: WardrobeItem, atIndexPath indexPath: IndexPath)
}

class AddItemViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, TypeSelectionDelegate, PurchaseDateDelegate, ImageSelectorDelegate {
    
    var fieldLabels : [UILabel] = []
    var userInputObjectDictionary = [String: [UIView]]() // holds uiview objects user will use to fill information based on label name
    var nameTextField : UserInputTextField!
    var typeButton : CurvedEdgeButton!
    var subtypeButton : CurvedEdgeButton!
    var purchaseSourceTextField : UserInputTextField!
    var brandNameTextField : UserInputTextField!
    var purchaseDateButton : CurvedEdgeButton!
    var colorTextFields : [UserInputTextField] = []
    var addColorButton : UIButton!
    var personLoanedToLabel : UILabel!
    
    let textFont = UIFont(name: "Marker Felt", size: 18.0)
    
    let dateFormatter = DateFormatter()
    
    var isTypeSelected : Bool {
        if let title = typeButton.title(for: .normal) {
            return title != "Choose Item Type"
        } else {
            return false
        }
    }
    var isDatePicked : Bool {
        if let _ = itemDate { return true }
        else { return false }
    }
    var personLoanedTo : String?
    
    // Item spacing
    let ySpacing = 15.0
    let xSpacing = 8.0

    @IBOutlet weak var loanButton: CurvedEdgeButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var submitButton: CurvedEdgeButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var imageSelector : ImageSelector?
    weak var delegate : AddItemDelegate?
    
    // Item selection fields
    var selectedItemIndexPath : IndexPath?

    // WardrobeItem fields
    var imageData : Data?
    var itemDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageSelector = ImageSelector(withDelegate: self)
        
        // Create all objects for user input
        createLabels()
        createUserInputDevices()
        
        // Need to set up handling for the keyboard appearing to keep everything visible when it appears
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Need Gesture Recognizer for getting rid of keyboard
        let dismissTap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(dismissTap)
    }
    
    func createLabels() {

        let labelNames = ["Name", "Type", "Subtype", "Purchased", "Brand", "Date Purchased", "Colors"]

        for name in labelNames {
            let label = UILabel(named: name)
            label.textColor = .primaryTextColor
            label.font = textFont
            fieldLabels.append(label)
        }
    }
    
    func createUserInputDevices() {
        
        // Add gesture recognizer for adding an image for the item
        let tapSelector = #selector(addImage(_:))
        let addImageTap = UITapGestureRecognizer(target: self, action: tapSelector)
        addImageTap.delegate = self
        itemImageView.addGestureRecognizer(addImageTap)
        itemImageView.isUserInteractionEnabled = true
        
        personLoanedToLabel = UILabel(frame: CGRect.zero)
        personLoanedToLabel.font = textFont
        personLoanedToLabel.textColor = .primaryTextColor
        
        nameTextField = UserInputTextField()
        nameTextField.placeholder = "Name"
        userInputObjectDictionary["Name"] = [nameTextField]
        
        typeButton = CurvedEdgeButton(named: "Choose Item Type")
        subtypeButton = CurvedEdgeButton(named: "Choose Item Subtype")
        subtypeButton.isEnabled = false
        typeButton.addTarget(self, action: #selector(chooseItemType(_:)), for: .touchUpInside)
        subtypeButton.addTarget(self, action: #selector(chooseItemSubtype(_:)), for: .touchUpInside)
        userInputObjectDictionary["Type"] = [typeButton]
        userInputObjectDictionary["Subtype"] = [subtypeButton]
        
        purchaseSourceTextField = UserInputTextField()
        purchaseSourceTextField.placeholder = "Store/Website Name"
        userInputObjectDictionary["Purchased"] = [purchaseSourceTextField]
        
        brandNameTextField = UserInputTextField()
        brandNameTextField.placeholder = "Brand name"
        userInputObjectDictionary["Brand"] = [brandNameTextField]
        
        purchaseDateButton = CurvedEdgeButton(named: "Choose Date")
        purchaseDateButton.addTarget(self, action: #selector(chooseItemPurchaseDate(_:)), for: .touchUpInside)
        userInputObjectDictionary["Date Purchased"] = [purchaseDateButton]
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        let colorTextField = UserInputTextField()
        colorTextField.placeholder = "E.g. Blue"
        colorTextFields.append(colorTextField)
        userInputObjectDictionary["Colors"] = colorTextFields
        
        addColorButton = UIButton(type: .contactAdd)
        addColorButton.contentHorizontalAlignment = .left
        addColorButton.addTarget(self, action: #selector(addExtraColor(_:)), for: .touchUpInside)
        userInputObjectDictionary["Colors"]!.append(addColorButton)
        
        mainScrollView.delegate = self
        nameTextField.delegate = self
        purchaseSourceTextField.delegate = self
        brandNameTextField.delegate = self
        colorTextField.delegate = self

    }
    
    override func viewDidLayoutSubviews() {
        
        // Layout all objects for user input
        var currentY = Double(itemImageView.frame.origin.y + itemImageView.frame.height) + ySpacing
        
        for label in fieldLabels {
            let origin = CGPoint(x: xSpacing, y: currentY)
            label.frame.origin = origin
            label.frame.size = label.intrinsicContentSize
            
            let labelFrame = label.frame
            // Now do layout of actual user input objects corresponding to this label
            if let views = userInputObjectDictionary[label.text!] {
                let currentX = xSpacing + Double(labelFrame.origin.x + labelFrame.width)
                for aView in views {
                    let viewOrigin = CGPoint(x: currentX, y: currentY)
                    let width = (Double(self.view.frame.width) - currentX -  xSpacing)
                    let viewSize = CGSize(width: width, height: 28.0)
                    aView.frame = CGRect(origin: viewOrigin, size: viewSize)
                    mainScrollView.addSubview(aView)
                    
                    currentY = currentY + Double(label.frame.size.height) + ySpacing
                }
            }
            
            mainScrollView.addSubview(label)
        }
        let bottomObjectFrame = userInputObjectDictionary[fieldLabels.last!.text!]!.last!.frame
        let scrollViewHeight = bottomObjectFrame.origin.y + bottomObjectFrame.size.height + CGFloat(ySpacing)
        mainScrollView.contentSize = CGSize(width: view.frame.width, height: scrollViewHeight)
    }
    
    //MARK:- Type Selection, Date Selection Delegates
    func selectType(_ type: String) {
        
        typeButton.setTitle(type, for: .normal)
        subtypeButton.isEnabled = true
    }
    
    func selectSubType(_ type: String) {
        
        subtypeButton.setTitle(type, for: .normal)
    }
    
    func selectPurchaseDate(_ date: Date) {
        
        itemDate = date
        let dateString = dateFormatter.string(from: date)
        purchaseDateButton.setTitle(dateString, for: .normal)
    }
    
    // MARK:- Keyboard Handlers
    @objc func keyboardWillShow(notification: Notification) {
        
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let contentInsets =  UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        mainScrollView.contentInset = contentInsets
//        mainScrollView.setContentOffset(CGPoint(x: 0.0, y: buildingInfoTextView.frame.origin.y), animated: true)
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        
        mainScrollView.contentInset = UIEdgeInsets.zero
        mainScrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    // MARK:- Gesture Recognizers
    
    @objc func addImage(_ sender: UITapGestureRecognizer) {
        
        imageSelector?.present(withViewController: self)
    }
    
    // MARK:- Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ChooseTypeSegue":
            let typeTableViewController = segue.destination as! TypeTableViewController
            typeTableViewController.delegate = self
            typeTableViewController.tableView.backgroundColor = .backgroundColor
            typeTableViewController.view.backgroundColor = .backgroundColor
            
        case "ChooseSubTypeSegue":
            let subtypeTableViewController = segue.destination as! SubTypeTableViewController
            subtypeTableViewController.delegate = self
            subtypeTableViewController.tableView.backgroundColor = .backgroundColor
            subtypeTableViewController.view.backgroundColor = .backgroundColor
            
        case "ChooseDateSegue":
            let dateViewController = segue.destination as! DatePickerViewController
            dateViewController.delegate = self
            dateViewController.view.backgroundColor = .backgroundColor
            
        case "UnwindFromItemDetail":
            break
            
        default:
            assert(false, "Unhandled segue from AddItemViewController")
        }
    }
    
    @IBAction func unwindToAddItemSegue(segue: UIStoryboardSegue) {
        
    }
    
    // MARK:- Action and Obj-C Methods
    
    @objc func chooseItemType(_ sender: UIButton) {
        performSegue(withIdentifier: "ChooseTypeSegue", sender: sender)
    }
    
    @objc func chooseItemSubtype(_ sender: UIButton) {
        performSegue(withIdentifier: "ChooseSubTypeSegue", sender: sender)
    }
    
    @objc func chooseItemPurchaseDate(_ sender: UIButton) {
        performSegue(withIdentifier: "ChooseDateSegue", sender: sender)
    }
    
    @objc func addExtraColor(_ sender: UIButton) {
        
        // Create a new textfield for another color to then be placed in view
        let newColorTextField = UserInputTextField()
        newColorTextField.placeholder = "E.g. Green"
        colorTextFields.append(newColorTextField)
        userInputObjectDictionary["Colors"] = colorTextFields
        userInputObjectDictionary["Colors"]!.append(addColorButton)
        self.view.setNeedsLayout()
        
        newColorTextField.delegate = self
    }
    
    @IBAction func loanOrUnloanItem(_ sender: UIButton) {
        
        if loanButton.title(for: .normal) == "Loan" {
            
            let alertController = UIAlertController(title: "Loan to:", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Confirm", style: .default, handler: {(alert) in
                let personLoanedTo = alertController.textFields?.first?.text
                self.addLoanedText(withPerson: personLoanedTo!)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            alertController.addTextField { (textField) in  }
            self.present(alertController, animated: true, completion: {
                self.loanButton.setTitle("Unloan", for: .normal)
            })

        } else {
            // UNLOAN
            loanButton.setTitle("Loan", for: .normal)
            
            UIView.animate(withDuration: 0.5, animations: {
                let x = self.personLoanedToLabel.frame.origin.x
                let y = CGFloat(-30.0)
                self.personLoanedToLabel.frame.origin = CGPoint(x: x, y: y)
                
            }, completion: {(complete) in
                self.personLoanedToLabel.text = nil
                self.personLoanedTo = nil
            })
        }
        
    }
    @IBAction func submitItem(_ sender: Any) {
        guard nameTextField.text != "", isTypeSelected, isDatePicked else { return }
        
        var colors : [String] = []
        for colorTextField in colorTextFields {
            if colorTextField.text != "" { colors.append(colorTextField.text!) }
        }
        
        let newItem = WardrobeItem(name: nameTextField.text!, type: typeButton.titleLabel!.text!, size: "Medium", subType: subtypeButton.titleLabel!.text, colors: colors, seasons: [], brandName: brandNameTextField.text!, price: nil, storeName: purchaseSourceTextField.text!, storeLocation: nil, imageName: "", imageData: imageData, dateOfPurchase: itemDate, loanedTo: personLoanedTo)
        delegate?.addNewItem(newItem)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Helper Functions
    
    func addLoanedText(withPerson person: String) {
        
        let loanedText = "Currently Loaned to \(person)"
        personLoanedToLabel.text = loanedText
        personLoanedTo = person
        
        // Place loanedTo label off the screen for animation
        personLoanedToLabel.frame.origin = CGPoint(x: self.view.frame.width, y: cancelButton.frame.origin.y)
        personLoanedToLabel.frame.size = personLoanedToLabel.intrinsicContentSize
        
        UIView.animate(withDuration: 1.0, animations: {
            let x = self.view.frame.width / 2 - self.personLoanedToLabel.frame.width / 2
            let y = self.cancelButton.frame.origin.y
            self.personLoanedToLabel.frame.origin = CGPoint(x: x, y: y)
            self.mainScrollView.addSubview(self.personLoanedToLabel)
        })
    }
}

// MARK:- Configure controller for a Detail view
extension AddItemViewController {
    
    func configureForDetailView(item: WardrobeItemMO, atIndexPath indexPath: IndexPath) {
        
        selectedItemIndexPath = indexPath
        titleLabel.text = item.name
        nameTextField.text = item.name
        typeButton.setTitle(item.type, for: .normal)
        subtypeButton.setTitle(item.subtype, for: .normal)
        purchaseSourceTextField.text = item.storeName
        brandNameTextField.text = item.brandName
        purchaseDateButton.setTitle(dateFormatter.string(from: item.dateOfPurchase!), for: .normal)
        colorTextFields[0].text = item.colors!.first
        for i in 1..<item.colors!.count {
            let newColorTextField = UserInputTextField()
            newColorTextField.text = item.colors![i]
            colorTextFields.append(newColorTextField)
            
            newColorTextField.delegate = self
        }
        userInputObjectDictionary["Colors"] = colorTextFields
        userInputObjectDictionary["Colors"]?.append(addColorButton)
        itemDate = item.dateOfPurchase!
        
        if let personLoanedTo = item.loanedTo {
            loanButton.setTitle("Unloan", for: .normal)
            addLoanedText(withPerson: personLoanedTo)
        }
        
        if let itemImageData = item.imageData {
            let itemImage = UIImage(data: itemImageData)
            itemImageView.image = itemImage!
            imageData = itemImageData
        }
        else {
            let itemImage = UIImage(named: "noImageFound")
            itemImageView.image = itemImage!
        }
        
        // Fields shouldn't be editable by default
        itemImageView.isUserInteractionEnabled = false
        for inputObjects in userInputObjectDictionary.values {
            for viewObject in inputObjects {
                viewObject.isUserInteractionEnabled = false
            }
        }
        
        loanButton.isHidden = false
        submitButton.isHidden = true
        editButton.isHidden = false
        cancelButton.isHidden = false
        
        self.view.setNeedsLayout()
    }
    
    @IBAction func toggleEditingFields(_ sender: Any) {
        
        if editButton.title(for: .normal) == "Edit" {
            editButton.setTitle("Done", for: .normal)
        }
        else {
            guard nameTextField.text != "", isTypeSelected, isDatePicked else { return }
            
            editButton.setTitle("Edit", for: .normal)
            submitItemChanges()
        }
        
        // Toggle fields' editable properties
        itemImageView.isUserInteractionEnabled.toggle()
        for inputObjects in userInputObjectDictionary.values {
            for viewObject in inputObjects {
                viewObject.isUserInteractionEnabled.toggle()
            }
        }
    }
    
    func submitItemChanges() {

        // FIXME: Add size and seasons
        var colors : [String] = []
        for colorTextField in colorTextFields {
            if colorTextField.text != "" { colors.append(colorTextField.text!) }
        }
        
        let item = WardrobeItem(name: nameTextField.text!, type: typeButton.title(for: .normal)!, size: "Medium", subType: subtypeButton.title(for: .normal), colors: colors, seasons: [], brandName: brandNameTextField.text!, price: nil, storeName: purchaseSourceTextField.text, storeLocation: nil, imageName: "", imageData: imageData, dateOfPurchase: itemDate, loanedTo: personLoanedTo)
        delegate?.updateItem(item,  atIndexPath: selectedItemIndexPath!)
    }

    // MARK:- Date Purchased Delegate
    
    func choosePurchaseDate(_ date: Date) {
        selectPurchaseDate(date)
    }

    // MARK:- Image Selector Delegate
  
    func selectedImage(image: UIImage) {
        
        itemImageView.image = image
        imageData = image.jpegData(compressionQuality: 1.0)
    }
}

extension AddItemViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
}

// MARK:- Image Selector

protocol ImageSelectorDelegate: NSObject {
    func selectedImage(image: UIImage)
}

class ImageSelector : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePickerViewController : UIImagePickerController
    weak var imageSelectorDelegate : ImageSelectorDelegate?
    
    init(withDelegate delegate: ImageSelectorDelegate) {
        
        imagePickerViewController = UIImagePickerController()
        super.init()
        
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        
        imageSelectorDelegate = delegate
    }
    
    func present(withViewController viewController: UIViewController) {
        
        // Let user choose between their camera and photos
        let photoAlertController = UIAlertController(title: "How?", message: nil, preferredStyle: .alert)
        
        // Create actions for each way of changing the photo
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        photoAlertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Use Camera", style: .default) { (action) in
                
                viewController.present(self.imagePickerViewController, animated: true, completion: nil)
            }
            photoAlertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let photoAction = UIAlertAction(title: "Browse Photos", style: .default) { (action) in
                guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else { return }
                
                viewController.present(self.imagePickerViewController, animated: true, completion: nil)
            }
            photoAlertController.addAction(photoAction)
        }
        
        viewController.present(photoAlertController, animated: true, completion: nil)
    }
    
    // MARK:- Image Picker Controller Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            imageSelectorDelegate?.selectedImage(image: selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    // Parts of the following function retrieved from https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
    func closestCommonColor() -> UIColor? {
        guard let image = CIImage(image: self) else { return nil }
        
        let extentVector = CIVector(x: image.extent.origin.x, y: image.extent.origin.y, z: image.extent.size.width, w: image.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: image, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap : [UInt8] = [0,0,0,0]
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        let averageColor = UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
        
        // FIXME: Now compare this to common colors to find closest match . Also put this in its own file
        return averageColor
    }
}
