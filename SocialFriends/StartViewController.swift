//
//  ViewController.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 3/5/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit
import CloudKit

class StartViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var db = Database()
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Error and loading indicator
        loadingIndicator.hidden = true
        errorMessageLabel.text = ""
        
    }
    
    @IBAction func returned(sender: UIStoryboard){
        // TODO: Return from register storyboard. using navigation controller or something.
        print("Testing")
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginSegue" {
            let tabBar = (segue.destinationViewController as! UINavigationController).topViewController as! TabBarViewController
            tabBar.user = user!
            tabBar.db = db
        } else if segue.identifier == "registerSegue" {
            let dest = segue.destinationViewController as? RegisterViewController
            dest!.db = self.db
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        login(usernameField.text!, password: passwordField.text!)
    }
    
    
    
    func login(username:String, password:String){
        errorMessageLabel.text = ""
        loadingIndicator.startAnimating()
        loadingIndicator.hidden = false
        
        db.login(username, password: password){
            user in
            
            if let u = user{
                self.user = u
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                }
            }else{
                dispatch_async(dispatch_get_main_queue()){
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.hidden = true
                    self.errorMessageLabel.text = "Username or Password are incorrect."
                }
            }
        }
    }
    
    @IBAction func registerPressed(sender: AnyObject) {
        performSegueWithIdentifier("registerSegue", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

