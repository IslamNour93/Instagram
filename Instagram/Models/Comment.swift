//
//  Comment.swift
//  Instagram
//
//  Created by Islam NourEldin on 10/08/2022.
//

import Firebase

struct Comment{
    
    var commentText:String
    var timestamp:Timestamp
    var uid:String
    var username:String
    var profileImageUrl:String
    
    init(dictionary:[String:Any]){
        
        commentText = dictionary["comment"] as? String ?? ""
        timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        username = dictionary["username"] as? String ?? ""
        profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        uid = dictionary["uid"] as? String ?? ""
    }
}
