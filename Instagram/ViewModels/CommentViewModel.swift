//
//  CommentViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 10/08/2022.
//

import Foundation

struct CommentViewModel{
    
    var comment: Comment
    
    var commentText:String{
        return comment.commentText
    }
    
    var username:String{
        return comment.username
    }
    
    var profileImageUrl:URL?{
        return URL(string: comment.profileImageUrl)
    }
    
    var userUid:String{
        return comment.uid
    }
    init(comment:Comment){
        self.comment = comment
    }
    
    func getAllPosts(postId:String,completion:@escaping ([Comment])->()){
        CommentService.fetchComments(postId: postId) { comments in
            completion(comments)
        }
    }
}
