//
//  User.swift
//  InstagramFirebase
//
//  Created by SEAN on 2017/12/10.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit

struct User {
    
    let uid: String
    let userName : String
    let profileImageUrl : String
    
    init(uid: String, dictionary : [String: Any]) {
        self.uid = uid
        self.userName = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
    
}
