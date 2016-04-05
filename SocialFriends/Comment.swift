//
//  Comment.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 3/9/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit
import CloudKit

class Comment: NSObject {
    
    let recordName: CKRecord
    let user: User
    let post: Post
    var content: String
    let time: NSDate
    var likes: [User]?
    
    init(recordName:CKRecord, user:User, post:Post, content: String, time:NSDate){
        self.recordName = recordName
        self.user = user
        self.post = post
        self.content = content
        self.time = time
    }
    
}
