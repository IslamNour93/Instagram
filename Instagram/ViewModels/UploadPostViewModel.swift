//
//  UploadPostViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 07/08/2022.
//

import Foundation
import UIKit

class UploadPostViewModel{
        
    func uploadPost(caption:String,image:UIImage,user:User,onSuccess:@escaping()->(),onFailure:@escaping(Error)->()){
        PostService.uploadPost(caption: caption, image: image, user: user) { error in
            if let error = error{
                onFailure(error)
                return
            }
            onSuccess()
        }
    }
    
    func getAllPosts(completion:@escaping([Post]?,Error?)->()){
        PostService.fetchAllPosts { posts, error in
            if let error = error {
                completion(nil,error)
                return
            }
            if let posts = posts {
                completion(posts,nil)
            }
        }
    }
    
    func getPostForUser(uid:String,completion:@escaping([Post]?,Error?)->()){
        PostService.fetchPostsForUser(uid: uid) { posts, error in
            if let error = error {
                completion(nil,error)
                return
            }
            if let posts = posts {
                completion(posts,nil)
            }
        }
    }
    
    func likePost(post:Post,completion:@escaping (Error?)->()){
        LikeService.likePost(post: post) { error in
            if error == nil{
                completion(nil)
            }else{
                print("DEBUG: Error can't like post...\(String(describing: error?.localizedDescription))")
                completion(error)
            }
        }
    }
    
    func unlikePost(post:Post,completion:@escaping (Error?)->()){
        LikeService.unlikePost(post: post) { error in
            if error == nil{
                completion(nil)
            }else{
                print("DEBUG: Error can't unlike post...\(String(describing: error?.localizedDescription))")
                completion(error)
            }
        }
    }
    
    func checkIfUserLikedPost(post:Post,completion:@escaping (Bool)->()){
        LikeService.checkIfUserLikedPost(post: post) { didLike in
            completion(didLike)
        }
    }
    
    func getPost(postId: String,completion:@escaping(Post?) -> ()){
        PostService.fetchPost(withPostId: postId) { post in
            completion(post)
        }
    }
    
    func updateFeedAfterFollowing(user:User,isFollowed:Bool,completion: @escaping (Error?)->()){
        PostService.updateFeedAfterFollowing(user: user, isFollowed: isFollowed) { error in
            if error == nil{
                completion(nil)
            }else{
            completion(error)
            }
        }
    }
    
    func fetchFeedPosts(completion:@escaping ([Post]?)->()){
        PostService.fetchFeedPosts { posts in
            if let posts = posts {
                completion(posts)
            }else{
                completion(nil)
            }
        }
    }
}
