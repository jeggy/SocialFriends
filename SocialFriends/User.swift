//
//  User.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 3/6/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit
import CloudKit

class User: NSObject {
    
    let record:CKRecord
    let username:String
    let fullname:String
    let gender:String
    let about:String
    private var friends: [User: FriendStatus] = [:]
    
    enum FriendStatus {
        case Accepted, Declined, Waiting
    }
    
    init(record:CKRecord, username:String, fullname:String, gender:String, about:String) {
        self.record = record
        self.username = username
        self.fullname = fullname
        self.gender = gender
        self.about = about
    }
    
    
    // Friends stuff
    func getFriends() -> [User]{
        return [User](friends.keys)
    }
    
    
    func getFriendsAndStatus() -> [User: FriendStatus]{
        return friends
    }
    
    func addFriend(user user: User, status: FriendStatus){
        friends.updateValue(status, forKey: user)
    }
    
    
}
