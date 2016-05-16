//
//  TabProfileViewController.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 3/6/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit

class TabProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameField: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var sentLabel: UILabel!
    
    var user:User!
    var me:User!
    var posts: [Post] = []
    var db:Database!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullnameLabel.text? = ""
        usernameField.text? = ""
        genderLabel.text? = ""
        aboutMeTextView.text? = ""
        sentLabel.hidden = true
        addFriendButton.hidden = true
//        self.tableView.estimatedRowHeight = 48.0;
//        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    override func viewDidAppear(animated: Bool) {
        loadProfile()
        loadFeed()
    }
    
    func loadProfile(){
        fullnameLabel.text = user.fullname
        usernameField.text = user.username
        genderLabel.text = user.gender
        aboutMeTextView.text = user.about
        
        
        // TODO: put in function or something.
        var text = "Add Friend"
        sentLabel.hidden = true
        addFriendButton.hidden = false
        for (friend, statusCode) in user.getFriendsAndStatus() {
            if friend.username == me.username{
                switch statusCode {
                case .Accepted:
                    text = "Unfriend"
                case .Waiting:
                    sentLabel.hidden = false
                    addFriendButton.hidden = true
                default: ()
                }
                break;
            }
        }
        
        addFriendButton.titleLabel!.text = text
    }
    
    
    
    
    func loadFeed(){
        dispatch_async(dispatch_get_main_queue()){
            self.posts = []
            self.tableViewLoadingIndicator.hidden = false
            self.tableViewLoadingIndicator.startAnimating()
        }
        
        db.loadUserPosts(user){
            posts in
            self.posts = posts
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
                self.tableViewLoadingIndicator.hidden = true
                self.tableViewLoadingIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func addFriendButtonPressed(sender: UIButton) {
        if Tools.areFriends(user, me){
            db.unFriend(user, me)
        }else{
            db.addFriend(user, me)
        }
        db.loadFriends(me, completionHandler: loadProfile)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.nameLabel?.text = post.user.fullname
        cell.timeLabel?.text = post.time.description // TODO:
        cell.contentTextView?.text = post.content
        cell.likesButton.setTitle(Tools.addS(post.likes!.count, text: "Like"), forState: .Normal)
        
        // TODO: I removed comments
        
//        cell.likesButton.tag = indexPath.row
//        cell.likesButton.addTarget(self, action: "likeOnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
