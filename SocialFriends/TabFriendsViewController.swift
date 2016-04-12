//
//  FriendsViewController.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 3/6/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit

class TabFriendsViewController: UITableViewController  {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var user:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("I don't think this class is used....")
        
        let tabBar = tabBarController as! TabBarViewController
        user = tabBar.user
        
        let inset = UIEdgeInsetsMake(30,0,0,0)
        self.tableView.contentInset = inset
        
        loadingIndicator.startAnimating()
        loadingIndicator.hidden = false
        
        
        tabBar.db.loadFriends(user){
            dispatch_async(dispatch_get_main_queue()){
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.hidden = true
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel!.text = user.getFriends()[indexPath.row].fullname
        cell.detailTextLabel?.text = user.getFriends()[indexPath.row].username
        
        cell.detailTextLabel?.font = UIFont.italicSystemFontOfSize(11.0)

        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.getFriends().count
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
