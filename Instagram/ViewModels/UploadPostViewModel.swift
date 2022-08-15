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
        PostService.fetchPostForUser(uid: uid) { posts, error in
            if let error = error {
                completion(nil,error)
                return
            }
            if let posts = posts {
                completion(posts,nil)
            }
        }
    }
    
    func likePost(post:Post,completion:@escaping ()->()){
        LikeService.likePost(post: post) { error in
            if error == nil{
                completion()
            }else{
                print("DEBUG: Error can't like post...\(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func unlikePost(post:Post,completion:@escaping ()->()){
        LikeService.unlikePost(post: post) { error in
            if error == nil{
                completion()
            }else{
                print("DEBUG: Error can't unlike post...\(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func checkIfUserLikedPost(post:Post,completion:@escaping (Bool)->()){
        LikeService.checkIfUserLikedPost(post: post) { didLike in
            completion(didLike)
        }
    }
}
