//
//  Tools.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 4/7/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

class Tools {
    
    static func addS(num: Int, text: String) -> String{
        return "\(num) \(text)\((num==1) ? "" : "s")"
    }
    
    static func areFriends(user1: User, _ user2: User) -> Bool{
        for (u, s) in user1.getFriendsAndStatus(){
            if u.username == user2.username && s == .Accepted{
                return true
            }
        }
        return false
    }
    
}
