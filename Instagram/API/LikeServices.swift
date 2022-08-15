//
//  LikeServices.swift
//  Instagram
//
//  Created by Islam NourEldin on 11/08/2022.
//

import Firebase

class LikeService{
    
    static func likePost(post:Post,completion:@escaping firebaseErrorCompletion){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Constants.collection_posts.document(post.postId).collection("post-likes").document(uid).setData([:]) { error in
            Constants.collection_posts.document(post.postId).updateData(["likes":post.likes+1])
            if error == nil{
                Constants.collection_users.document(uid).collection("user-likes").document(post.postId).setData([:], completion: completion)
            }
        }
    }
    
    static func unlikePost(post:Post,completion:@escaping firebaseErrorCompletion){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        guard post.likes > 0 else{return}
                
        Constants.collection_posts.document(post.postId).collection("post-likes").document(uid).delete { error in
            if error == nil{
                Constants.collection_posts.document(post.postId).updateData(["likes":post.likes-1])
                Constants.collection_users.document(uid).collection("user-likes").document(post.postId).delete(completion: completion)
            }
        }
    }
    
    static func checkIfUserLikedPost(post:Post,completion:@escaping (Bool)->()){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Constants.collection_users.document(uid).collection("user-likes").document(post.postId).getDocument { snapshot, error in
            
            if let error = error{
                print("DEBUG: Error can't Check User Stat..\(error.localizedDescription)")
                return
            }
            guard let didLike = snapshot?.exists else {return}
            completion(didLike)
        }
    }
}
