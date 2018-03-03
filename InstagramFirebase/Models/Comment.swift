//
//  Comment.swift
//  InstagramFirebase
//
//  Created by SEAN on 2018/1/15.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

struct Comment {
    
    let user: User
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
