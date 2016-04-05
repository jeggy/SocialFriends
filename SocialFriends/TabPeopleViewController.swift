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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar = tabBarController as! TabBarViewController
        
//        tabBar.tabBar.items?[1].badgeValue = "2"
        
        tabBar.db.loadAllUsers(completionHandler: whenUsersLoaded)
    }
    
    @IBAction func returned(sender: UIStoryboardSegue){
        print("returned PeopleView")
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
        
        self.people.sortInPlace{
            u1, u2 in
            for user in u1.friends!{
                if user.username == self.tabBar.user.username{
                    return true
                }
            }
            return false
        }
        
        dispatch_async(dispatch_get_main_queue()){
            self.tableView.reloadData()
        }
    }
    
    
    
    // Searching filter
    func searchFilter(user: User) -> Bool{
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
//        cell.textLabel!.text = users[indexPath.row].fullname
//        cell.detailTextLabel?.text = users[indexPath.row].username
        
        cell.detailTextLabel?.font = UIFont.italicSystemFontOfSize(11.0)
        
        return cell
    }
    
    func highligtSearch(label: UILabel, text: String, highligt: String){
        label.text! = text
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.filter(searchFilter).count
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
