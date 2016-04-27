//
//  TabSettingsViewController.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 3/5/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit

class TabSettingsViewController: UIViewController {

    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var aboutTextField: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        // Navigation bar.
        self.tabBarController!.navigationItem.title = "Settings"
        let updateButton = UIBarButtonItem(title: "Logout", style: .Done, target: self, action: #selector(TabSettingsViewController.logoutPressed(_:)))
        self.tabBarController!.navigationItem.rightBarButtonItem = updateButton
    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
        print("TODO: Logout!")
    }
    
    @IBAction func updatePressed(sender: AnyObject){
        
        print("Test")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
