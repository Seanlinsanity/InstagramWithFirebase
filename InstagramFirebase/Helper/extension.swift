//
//  extension.swift
//  InstagramFirebase
//
//  Created by SEAN on 2017/11/3.
//  Copyright © 2017年 SEAN. All rights reserved.
//

import UIKit
import Firebase

extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            //print(user.userName)
            completion(user)
            
        }, withCancel: nil)
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        }else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        }else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        }else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        }else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        }else{
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    }
}

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func mainBlue() -> UIColor {
        return UIColor.rgb(red: 17, green: 154, blue: 237)
    }
}

