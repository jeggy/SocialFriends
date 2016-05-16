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
        sender.enabled = false
        let buttonRow = sender.tag
        
        if checkIfLiked(posts[buttonRow]){
            sender.titleLabel!.text = "Like"
            db.unLike(posts[buttonRow], user: user){
                for i in 0...self.posts[buttonRow].likes!.count-1{
                    if self.posts[buttonRow].likes![i].username == self.user.username{
                        self.posts[buttonRow].likes!.removeAtIndex(i)
                        break
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    sender.enabled = true
                }
            }
        }else{
            sender.titleLabel!.text = "Unlike"
            db.like(posts[buttonRow], user: user){
                self.posts[buttonRow].likes?.append(self.user)
                
                dispatch_async(dispatch_get_main_queue()){
                    sender.enabled = true
                }
            }
        }
        
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
            
            cell.likeButton.titleLabel!.text = (!checkIfLiked(post)) ? "Like " : "Unlike"
            cell.likeButton.tag = indexPath.row-1
            cell.likeButton.addTarget(self, action: #selector(TabFeedViewController.likeOnPressed(_:)), forControlEvents: .TouchUpInside)
            
            return cell
        }
        
        newPostField = tableView.dequeueReusableCellWithIdentifier("newPostCell", forIndexPath: indexPath) as! NewPostTableViewCell
        return newPostField
    }
    
    func checkIfLiked(post: Post) -> Bool{
        if let likes = post.likes{
            for like in likes{
                if like.username == user.username{
                    return true
                }
            }
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
