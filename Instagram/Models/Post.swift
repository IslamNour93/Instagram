//
//  Post.swift
//  Instagram
//
//  Created by Islam NourEldin on 07/08/2022.
//

import Firebase

struct Post{
    
    var timestamp: Timestamp
    var likes: Int
    let imageUrl:String
    var caption:String
    let ownerUid:String
    var postId:String
    let ownerImageUrl:String
    let ownerUsername:String
    var didLike = false
    
    init(postId:String,dictionary:[String:Any]){
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        self.postId = postId
    }
}
