//
//  Post.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 3/9/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit
import CloudKit

class Post: NSObject {
    
    let recordName: CKRecord
    let user: User
    var content: String
    let time: NSDate
    var likes: [User]?
    var comments: [Comment]?
    
    init(recordName:CKRecord, user:User, content:String, time:NSDate){
        self.recordName = recordName
        self.user = user
        self.content = content
        self.time = time
    }
    
    
}
