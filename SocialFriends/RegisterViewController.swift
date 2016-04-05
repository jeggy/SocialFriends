//
//  RegisterViewController.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 3/6/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit
import CloudKit

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var genderSelected = 0
    
    var db:Database!
    var user: User?
    
    let gender = ["Male", "Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderPicker.delegate = self
        usernameField.delegate = self
        
        errorMessageLabel.text = ""
        loadingIndicator.hidden = true
        loadingIndicator.stopAnimating()
        
        
    }

    // TODO:
    @IBAction func returned(sender: UIStoryboardSegue){}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "registeredSegue" {
            let dest = segue.destinationViewController as? TabBarViewController
            dest?.user = user!
            dest?.db = db
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false
    }
    
    
    var usernameValid = false
    func textFieldDidEndEditing(textField: UITextField) {
        usernameValid = false
        
        errorMessageLabel.text = ""
        loadingIndicator.startAnimating()
        loadingIndicator.hidden = false
        
        
        db.usernameExists(usernameField.text!){
            exists in
            dispatch_async(dispatch_get_main_queue()) {
                self.usernameValid = !exists
                if(exists){
                    self.errorMessageLabel.text = "Username already taken"
                }
                self.loadingIndicator.hidden = true
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    
    @IBAction func registerPressed(sender: AnyObject) {
        let username = usernameField.text!
        let password = passwordField.text!
        let repeatPassword = repeatPasswordField.text!
        let fullname = fullnameField.text!
        let gender = self.gender[genderSelected]
        
        if usernameValid && password == repeatPassword && password.characters.count > 0 && fullname.characters.count > 0 {
            db.register(username, password: password, fullname: fullname, gender: gender){
                user in
                self.user = user
                dispatch_async(dispatch_get_main_queue()){
                    self.performSegueWithIdentifier("registeredSegue", sender: self)
                }
            }
        } else {
            errorMessageLabel.text = "Please fill out fields"
        }
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderSelected = row
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
