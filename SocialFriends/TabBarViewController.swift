//
//  TabBarViewController.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 3/6/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var user:User!
    var db:Database!
    
    
    @IBAction func returned(sender: UIStoryboardSegue){
        print("returned Main TabBar")
    }
}
