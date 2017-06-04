//
//  RaffleRequestViewController.swift
//  FashionRaffle
//
//  Created by Mac on 6/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class RaffleRequestViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var categoryDropdown: UIPickerView!
    
    @IBOutlet weak var backer: UITextField!
    
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var category: UIButton!
    var list = ["Fashion", "Luxury", "Make Up", "Electronic", "Others"]
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryDropdown.isHidden = true
        // Do any additional setup after loading the view.
        
        price.delegate = self
        price.keyboardType = UIKeyboardType.decimalPad
        backer.delegate = self
        backer.keyboardType = UIKeyboardType.decimalPad
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    func pickerView(_ categoryDropdown: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return list[row]
    }
    
    func pickerView(_ categoryDropdown: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.category.setTitle(self.list[row], for: .normal)
        self.categoryDropdown.isHidden = true
    }
    
   
    @IBAction func showCategory(_ sender: Any) {
        self.categoryDropdown.isHidden = false
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String)
        -> Bool
    {
        // We ignore any change that doesn't add characters to the text field.
        // These changes are things like character deletions and cuts, as well
        // as moving the insertion point.
        //
        // We still return true to allow the change to take place.
        if string.characters.count == 0 {
            return true
        }
        
        // Check to see if the text field's contents still fit the constraints
        // with the new content added to it.
        // If the contents still fit the constraints, allow the change
        // by returning true; otherwise disallow the change by returning false.
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        switch textField {
            case backer:
                let decimalSeparator = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
                return prospectiveText.isNumeric() &&
                    prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) &&
                    prospectiveText.characters.count <= 5
            
            case price:
                let decimalSeparator = (Locale.current as NSLocale).object(forKey: NSLocale.Key.decimalSeparator) as! String
                return prospectiveText.isNumeric() &&
                    prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator) &&
                    prospectiveText.characters.count <= 4
        default:
            return true
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

}
