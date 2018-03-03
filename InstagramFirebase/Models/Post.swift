//
//  Post.swift
//  InstagramFirebase
//
//  Created by SEAN on 2017/12/2.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit

struct Post {
    
    var id: String?
    var hasLiked: Bool = false
    let user: User
    let imageUrl : String
    let caption: String
    let creationDate: Date
    
    init(user: User, dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}

