//
//  TabSettingsViewController.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 3/5/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit

class TabSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        // Navigation bar.
        self.tabBarController!.navigationItem.title = "Settings"
        let updateButton = UIBarButtonItem(title: "Update", style: .Done, target: self, action: #selector(TabSettingsViewController.updatePressed(_:)))
        self.tabBarController!.navigationItem.rightBarButtonItem = updateButton
    }
    
    @IBAction func updatePressed(sender: AnyObject){
        print("Test")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
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
