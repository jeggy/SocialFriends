//
//  Database.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 3/7/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit
import CloudKit

class Database: NSObject {
    
    var db:CKDatabase
    
    override init(){
        db = CKContainer.defaultContainer().publicCloudDatabase
    }
    
    /* Posts functions */
    func postStatus(user:User, text:String, completionHandler ch: (post: Post) -> Void){
        let record = CKRecord(recordType: "post")
        
        let now = NSDate()
        
        record.setObject(text, forKey: "content")
        record.setObject(now, forKey: "time")
        record.setObject(CKReference(record: user.record, action: .DeleteSelf), forKey: "user")
        
        db.saveRecord(record){
            r, error -> Void in
            let post = Post(recordName: record, user: user, content: text, time: now)
            post.comments = []
            post.likes = []
            ch(post: post)
        }
    }
    
    func getFeed(user:User, comletionHander ch: (posts:[Post]) -> Void){
        let startLoadingFeed = {
            var allPosts:[Post] = []
            var userCount = 0
            
            let userFeedLoaded:([Post])->Void = {
                posts in
                userCount -= 1
                allPosts += posts
                if userCount == 0{
                    ch(posts: allPosts)
                }
            }
            
            self.loadFeed(user.record, completionHandler: userFeedLoaded)
            if user.getFriends().count == 0 {ch(posts: [])}
            
            let filtered = user.getFriendsAndStatus().filter({$1 == User.FriendStatus.Accepted})
            
            for (friend, _) in filtered{
                userCount += 1
                self.loadFeed(friend.record, completionHandler: userFeedLoaded)
            }
            
        }
        
        // Load friends first if not loaded.
        loadFriends(user, completionHandler: startLoadingFeed)

    }
    
    func loadUserPosts(user:User, comletionHander ch: (posts:[Post]) -> Void){
        loadFeed(user.record){ch(posts: $0)}
    }
    
    func loadFeed(userRecord: CKRecord, completionHandler ch: (posts: [Post]) -> Void){
        let predicate = NSPredicate(format: "user == %@", CKReference(record: userRecord, action: .DeleteSelf))
        let query = CKQuery(recordType: "post", predicate: predicate)
        
        db.performQuery(query, inZoneWithID: nil){
            records, error in
            
            if error == nil{
                var posts:[Post] = []
                
                var c = records!.count*2
                // TODO: // if records?.count == 0 {ch(posts: [])}
                for record in records!{
                    let user = record.objectForKey("user") as! CKReference
                    let content = record.objectForKey("content") as! String
                    let time = record.objectForKey("time") as! NSDate
                    
                    self.loadUser(user){
                        user in

                        let post = Post(recordName: record, user: user!, content: content, time: time)
                        posts.append(post)
                        
                        let f = {
                            c -= 1
                            if c == 0{
                                ch(posts: posts)
                            }
                        }
                        
                        self.loadPostComments(post, completionHandler: f)
                        self.loadPostLikes(post, completionHandler: f)
                    }
                }
            }
        }
    }
    
    func loadPostComments(post: Post, completionHandler ch: () -> Void){
        post.comments = []
        let predicate = NSPredicate(format: "post == %@", CKReference(record: post.recordName, action: .DeleteSelf))
        let query = CKQuery(recordType: "comment", predicate: predicate)

        db.performQuery(query, inZoneWithID: nil){
            records, error in
            if error == nil{
                var c = records!.count
                if c == 0 {
                    ch()
                }
                for record in records!{
                    let userReference = record.objectForKey("user") as! CKReference
                    let content = record.objectForKey("content") as! String
                    let time = record.objectForKey("time") as! NSDate
                    
                    self.loadUser(userReference){
                        user in
                        let comment = Comment(recordName: record, user: user!, post: post, content: content, time: time)
                        self.loadCommentLikes(comment){
                            post.comments!.append(comment)
                            c -= 1
                            if c == 0{
                                ch()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadCommentLikes(comment:Comment, completionHandler ch: () -> Void){
        comment.likes = []
        let predicate = NSPredicate(format: "comment == %@", CKReference(record: comment.recordName, action: .DeleteSelf))
        let query = CKQuery(recordType: "like_comment", predicate: predicate)

        db.performQuery(query, inZoneWithID: nil){
            records, error in

            if error == nil{
                var c = records!.count
                if c == 0 {
                    ch()
                }
                for record in records!{
                    self.loadUser(record.objectForKey("user") as! CKReference){
                        user in
                        comment.likes!.append(user!)
                        c -= 1
                        if c == 0{
                            ch()
                        }
                    }
                }
            }
        }
        
        
        load(5, completionHandler: {
            returnValue in
            print("load function returned: \(returnValue)")
        })
        
    }
    
    func load(asdf:Int, completionHandler ch: (returnValue:Bool) -> Void){
        if(asdf == 5){
            ch(returnValue: true)
        }else{
            ch(returnValue: false)
        }
    }
    
    func loadPostLikes(post:Post, completionHandler ch: () -> Void){
        post.likes = []
        let predicate = NSPredicate(format: "post == %@", CKReference(record: post.recordName, action: .DeleteSelf))
        let query = CKQuery(recordType: "like_post", predicate: predicate)
        
        db.performQuery(query, inZoneWithID: nil){
            records, error in
            if error == nil{
                var c = records!.count
                if c == 0 {
                    ch()
                }
                for record in records!{
                    self.loadUser(record.objectForKey("user") as! CKReference){
                        user in
                        post.likes!.append(user!)
                        c -= 1
                        if c == 0{
                            ch()
                        }
                    }
                }
            }
        }
    }
    
    func like(post: Post, user: User, completionHandler ch: () -> Void){
        let record = CKRecord(recordType: "like_post")
        
        record.setObject(CKReference(record: post.recordName, action: .DeleteSelf), forKey: "post")
        record.setObject(NSDate(), forKey: "time")
        record.setObject(CKReference(record: user.record, action: .DeleteSelf), forKey: "user")
        
        db.saveRecord(record){_,_ in ch()}
    }
    
    func unLike(post: Post, user: User, completionHandler ch: () -> Void){
        let postRef = CKReference(record: post.recordName, action: .DeleteSelf)
        let userRef = CKReference(record: user.record, action: .DeleteSelf)
        
        let predicate = NSPredicate(format: "post == %@ AND user == %@", postRef, userRef)
        let query = CKQuery(recordType: "post_like", predicate: predicate)
        
        db.performQuery(query, inZoneWithID: nil){
            records, error in
            for record in records!{
                self.db.deleteRecordWithID(record.recordID){
                    _,_ in
                    ch()
                }
            }
            if records?.count == 0 || error != nil{
                // TODO: Some warning.
                ch()
            }
        }
    }
    
    /* *** User functions *** */
    func login(username:String, password: String, completionHandler ch: (User? -> Void)){
        let predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        let query = CKQuery(recordType: "user", predicate: predicate)
        
        
        db.performQuery(query, inZoneWithID: nil){
            records, error in
            
            if error == nil {
                if records?.count > 0{
                    // Logged in successfully
                    let username = records?[0].objectForKey("username") as! String
                    let fullname = records?[0].objectForKey("fullname") as! String
                    let gender = records?[0].objectForKey("gender") as! String
                    let about = records?[0].objectForKey("about") as! String
                    
                    ch(User(record: records![0], username: username, fullname: fullname, gender: gender, about: about))
                    return
                }
            }else{
                // TODO: This error happends when user is not connected to iCloud
                print("Error: \(error)\n 'Login into iCloud on your device'")
            }
            ch(nil)
        }
    }
    
    
    func usernameExists(username:String, completionHandler ch: (exists: Bool) -> Void){
        let predicate = NSPredicate(format: "username == %@", username)
        let query = CKQuery(recordType: "user", predicate: predicate)
        
        db.performQuery(query, inZoneWithID: nil){
            (records, error) -> Void in
            
            ch(exists: error == nil && records?.count > 0)
        }
    }
    
    func register(username:String, password:String, fullname:String, gender:String, completionHandler ch: (user:User) -> Void){
        let record = CKRecord(recordType: "user")
        
        record.setObject(username, forKey: "username")
        record.setObject(password, forKey: "password")
        record.setObject(fullname, forKey: "fullname")
        record.setObject(gender, forKey: "gender")
        record.setObject("", forKey: "about")
        record.setObject(NSDate(), forKey: "last_action")        
        
        db.saveRecord(record){
            r, error -> Void in
            let user = User(record: r!, username: username, fullname: fullname, gender: gender, about: "")
            ch(user: user)
        }
    }
    
    func loadAllUsers(completionHandler ch: (users: [User]) -> Void){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "user", predicate: predicate)
        
        var users: [User] = []
        db.performQuery(query, inZoneWithID: nil){
            records, error in
            
            if error == nil {
                var count = records!.count
                for record in records!{
                    let username = record.objectForKey("username") as! String
                    let fullname = record.objectForKey("fullname") as! String
                    let gender = record.objectForKey("gender") as! String
                    let about = record.objectForKey("about") as! String
                    let user = User(record: record, username: username, fullname: fullname, gender: gender, about: about)
                    
                    self.loadFriends(user) {
                        count -= 1
                        if count == 0{
                            ch(users:users)
                        }
                    }
                    
                    users.append(user)
                }
            }
        }
    }
    
    func loadFriends(user: User, completionHandler ch: () -> Void){
        let predicate1 = NSPredicate(format: "user_one == %@", user.record)
        let predicate2 = NSPredicate(format: "user_two == %@", user.record)
        let query1 = CKQuery(recordType: "friends", predicate: predicate1)
        let query2 = CKQuery(recordType: "friends", predicate: predicate2)
        
        var friendsCount = 0
        var both = false
        let f:()->Void = {
            if friendsCount == 0 && both {
                ch()
            }
        }
        
        
        db.performQuery(query1, inZoneWithID: nil){
            (records, error) -> Void in
            
            friendsCount += records!.count
            if(records!.count==0){
                f()
            }
            for record in records!{
                self.loadUser(record.objectForKey("user_two") as! CKReference){
                    friend in
                    let status: User.FriendStatus!
                    switch record.objectForKey("accepted") as! NSString{
                        case "yes": status = .Accepted
                        case "no": status = .Declined
                        default: status = .Waiting
                    }
                    
                    user.addFriend(user: friend!, status: status)
                    friendsCount -= 1
                    f()
                }
            }
            both = true
        }
        
        
        
        db.performQuery(query2, inZoneWithID: nil){
            (records, error) -> Void in
            
            friendsCount += records!.count
            if(records!.count==0){
                f()
            }
            for record in records!{
                self.loadUser(record.objectForKey("user_one") as! CKReference){
                    friend in
                    let status: User.FriendStatus!
                    switch record.objectForKey("accepted") as! NSString{
                        case "yes": status = .Accepted
                        case "no": status = .Declined
                        default: status = .Waiting
                    }
                    user.addFriend(user: friend!, status: status)
                    friendsCount -= 1
                    f()
                }
            }
            
            both = true
        }
    }
    
    func addFriend(user1: User, _ user2: User){
        let record = CKRecord(recordType: "friends")
        
        record.setObject(CKReference(record: user1.record, action: .DeleteSelf), forKey: "user_one")
        record.setObject(CKReference(record: user2.record, action: .DeleteSelf), forKey: "user_two")
        record.setObject("", forKey: "accepted")
        record.setObject(NSDate(), forKey: "time")
        
        db.saveRecord(record){record,error in
            print("Test")
            error?.description
        }
    }
    
    func unFriend(user1: User, _ user2: User){
        let ref1 = CKReference(record: user1.record, action: .DeleteSelf)
        let ref2 = CKReference(record: user2.record, action: .DeleteSelf)
        let predicate1 = NSPredicate(format: "user_one == %@ AND user_two == %@", ref1, ref2)
        let predicate2 = NSPredicate(format: "user_one == %@ AND user_two == %@", ref2, ref1)
        let query1 = CKQuery(recordType: "friends", predicate: predicate1)
        let query2 = CKQuery(recordType: "friends", predicate: predicate2)
        
        let rr: ([CKRecord]) -> Void = {
            records in
            for record in records{
                self.db.deleteRecordWithID(record.recordID){_,_ in}
            }
        }
        
        db.performQuery(query1, inZoneWithID: nil){r,e in rr(r!)}
        db.performQuery(query2, inZoneWithID: nil){r,e in rr(r!)}
    }
    
    func loadUser(userReference:CKReference, completionHandler ch: (user:User?) -> Void){
        db.fetchRecordWithID(userReference.recordID){
            record, error in
            let username = record?.objectForKey("username") as! String
            let fullname = record?.objectForKey("fullname") as! String
            let gender = record?.objectForKey("gender") as! String
            let about = record?.objectForKey("about") as! String
            
            ch(user: User(record: record!, username: username, fullname: fullname, gender: gender, about: about))
        }
    }
}
