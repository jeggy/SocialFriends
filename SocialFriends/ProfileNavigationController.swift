//
//  ProfileNavigationController.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 4/5/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit

class ProfileNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Delete this file.
        print("I don't think is used...")
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func returned(sender: UIStoryboardSegue){
        print(sender.destinationViewController)
        print(sender.identifier)
        print("test")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
