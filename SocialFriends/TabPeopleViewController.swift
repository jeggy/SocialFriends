//
//  TabPeopleViewController.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 4/1/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit

class TabPeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var people: [User] = []

    var tabBar: TabBarViewController!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var selectedProfile = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar = tabBarController as! TabBarViewController
        
//        tabBar.tabBar.items?[1].badgeValue = "2" more comment test
        loadingIndicator.startAnimating()
        tabBar.db.loadAllUsers(completionHandler: whenUsersLoaded)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.navigationItem.title = "People"
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    
    @IBAction func returned(sender: UIStoryboardSegue){
        print("returned PeopleView")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "viewProfileSegue"){
            let tab = segue.destinationViewController as! TabProfileViewController
            tab.user = people[selectedProfile]
            tab.db = tabBar.db
            tab.me = tabBar.user
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false
    }
    
    @IBAction func searchFieldEdited(sender: UITextField) {
        self.tableView.reloadData()
    }
    
    func whenUsersLoaded(users: [User]){
        self.people = users
        
        // Remove self
        for i in 0 ..< self.people.count{
            if self.people[i].username.isEqual(tabBar.user.username){
                self.people.removeAtIndex(i)
                break;
            }
        }
        
        self.people.sortInPlace{Tools.areFriends($0, $1)}
        
        dispatch_async(dispatch_get_main_queue()){
            self.tableView.reloadData()
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
        }
    }
    
    
    
    // Searching filter
    func searchFilter(user: User) -> Bool{
        if searchTextField.text!.isEmpty{
            return Tools.areFriends(self.tabBar.user, user)
        }
        
        let c1 = user.username.rangeOfString(searchTextField.text!, options: .CaseInsensitiveSearch) != nil
        let c2 = user.fullname.rangeOfString(searchTextField.text!, options: .CaseInsensitiveSearch) != nil
        return c1 || c2
    }
    
    // TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath)
        
        let users = people.filter(searchFilter)
        
        highligtSearch(cell.textLabel!, text: users[indexPath.row].fullname, highligt: searchTextField.text!)
        highligtSearch(cell.detailTextLabel!, text: users[indexPath.row].username, highligt: searchTextField.text!)
        
        cell.detailTextLabel?.font = UIFont.italicSystemFontOfSize(11.0)
        cell.accessoryType = Tools.areFriends(people.filter(searchFilter)[indexPath.row], tabBar.user) ? .Checkmark : .None
        
        return cell
    }
    
    func highligtSearch(label: UILabel, text: String, highligt: String){
        label.text! = text
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTextField.text!.isEmpty ?
            people.filter({Tools.areFriends($0, tabBar.user)}).count : people.filter(searchFilter).count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedProfile = indexPath.row
        performSegueWithIdentifier("viewProfileSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
