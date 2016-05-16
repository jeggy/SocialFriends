//
//  PostTableViewCell.swift
//  SocialFriends
//
//  Created by Jógvan Olsen on 3/18/16.
//  Copyright © 2016 Jógvan Olsen. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var likesButton: UIButton!
    @IBAction func likesButtonPressed(sender: UIButton) {}
    
    @IBOutlet weak var likeButton: UIButton!
    @IBAction func likePressed(sender: UIButton) {}
    
    
    
}
