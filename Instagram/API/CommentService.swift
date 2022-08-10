//
//  CommentService.swift
//  Instagram
//
//  Created by Islam NourEldin on 09/08/2022.
//

import Firebase

class CommentService{
    
    static func postComment(forpost commentText:String,postId:String,user: User,completion: @escaping firebaseErrorCompletion){
        let data:[String:Any] = ["uid":user.uid,
                                 "comment":commentText,
                                 "timestamp":Timestamp(date: Date()),
                                 "username":user.username,
                                 "profileImageUrl":user.profileImageUrl]
        Constants.collection_posts.document(postId).collection("comments").document().setData(data, completion: completion)
    }
}
