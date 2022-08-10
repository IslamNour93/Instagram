//
//  User.swift
//  Instagram
//
//  Created by Islam NourEldin on 02/08/2022.
//

import Foundation
import Firebase

struct User{
    var email:String
    var fullname:String
    var username:String
    var profileImageUrl:String
    var uid:String
    var userStats: UserStats
    var isFollowed = false
    
    var isCurrentUser:Bool{
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(dictionary:[String:Any]){
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        userStats = UserStats(followers: 0, following: 0, posts: 0)
    }
}

struct UserStats{
    var followers:Int
    var following:Int
    var posts:Int
}
