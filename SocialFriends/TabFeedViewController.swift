//
//  TabFeedViewController.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 3/5/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit

class TabFeedViewController: UITableViewController {
    
    var posts:[Post] = []
    var db: Database!
    var user: User!
    
    @IBOutlet weak var postStatusField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inset = UIEdgeInsetsMake(55,0,0,0) // TODO: Fix this.
        self.tableView.contentInset = inset
        
        let tabBar = tabBarController as! TabBarViewController
        db = tabBar.db
        user = tabBar.user
        loadFeed()
        
        // Enable reload gesture
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "")
        self.refreshControl!.addTarget(self, action: #selector(TabFeedViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarController!.navigationItem.title = "News feed"
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    func refresh(sender:AnyObject){
        loadFeed()
    }
    
    func loadFeed(){
        dispatch_async(dispatch_get_main_queue()){
            self.posts = []
            self.tableView.reloadData()
            self.refreshControl!.beginRefreshing()
        }
        
        db.getFeed(user){
            posts in
            self.posts = posts
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
                self.reloadInputViews()
                self.refreshControl!.endRefreshing()
            }
        }
    }
    
    @IBAction func postStatusPressed(sender: AnyObject) {
        let text = newPostField!.newPostTextField.text
        db.postStatus(user, text: text){
            post in
            self.posts.insert(post, atIndex: 0)
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
                self.newPostField!.newPostTextField.text = ""
            }
        }
    }
    
    @IBAction func likeOnPressed(sender: UIButton) {
        let buttonRow = sender.tag
//        db.like(post: posts[buttonRow], user: user){
//            
//        }
        print(posts[buttonRow].content)
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count+1
    }
    
    var newPostField: NewPostTableViewCell!
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row != 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostTableViewCell
            let post = posts[indexPath.row-1]
            cell.nameLabel?.text = post.user.fullname
            cell.timeLabel?.text = post.time.description // TODO:
            cell.contentTextView?.text = post.content
            cell.likesButton.setTitle(Tools.addS(post.likes!.count, text: "Like"), forState: .Normal)
            cell.commentsButton.setTitle(Tools.addS(post.comments!.count, text: "Comment"), forState: .Normal)
            
            cell.likesButton.tag = indexPath.row-1
            cell.likesButton.addTarget(self, action: #selector(TabFeedViewController.likeOnPressed(_:)), forControlEvents: .TouchUpInside)
            
            return cell
        }
        
        newPostField = tableView.dequeueReusableCellWithIdentifier("newPostCell", forIndexPath: indexPath) as! NewPostTableViewCell
        return newPostField
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
