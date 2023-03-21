//
//  AddPageViewController.swift
//  SqlLite
//
//  Created by Admin on 19/03/23.
//

import UIKit

class AddPageViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var marksTextField: UITextField!
    
    var fName:String?
    var lName:String?
    var marks:Int?
    var oldData:Student?
    
    var update:Bool = false
    var db = DBManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.text = fName
        lastNameTextField.text = lName
        marksTextField.text = marks?.codingKey.stringValue
    }
    
    @IBAction func saveButtonClick(_ sender: UIBarButtonItem) {
        
        if firstNameTextField.text!.isEmpty ||
            lastNameTextField.text!.isEmpty ||
            marksTextField.text!.isEmpty {
            print("Empty TextField Not allowed")
        }
        else{
            // Save Data on here
            fName = firstNameTextField.text
            lName = lastNameTextField.text
            marks = Int(marksTextField.text!)
            if(update){
                db.update(fname: fName!, lname: lName!, marks: marks!, s: oldData!)
                update = false
            }
            else{
                db.insert(fname: fName!, lname: lName!, marks: marks!)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}

