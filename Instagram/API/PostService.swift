//
//  PostService.swift
//  Instagram
//
//  Created by Islam NourEldin on 07/08/2022.
//

import Firebase
import UIKit

class PostService{
    
    static func uploadPost(caption:String,image:UIImage,user:User,completion:@escaping firebaseErrorCompletion){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        ImageUploader.uploadProfileImage(profileImage: image) { imageUrl in
            
            let data = ["ownerUid":currentUid,
                        "caption":caption,
                        "imageUrl":imageUrl,
                        "timestamp":Timestamp(date: Date()),
                        "likes":0,
                        "ownerUsername":user.username,
                        "ownerImageUrl":user.profileImageUrl] as [String:Any]
            Constants.collection_posts.addDocument(data: data,completion: completion)
        }
    }
    
    static func fetchAllPosts(completion:@escaping([Post]?,Error?)->()){
        
        Constants.collection_posts.order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                return
            }
            let posts = snapshot.documents.map({Post(postId: $0.documentID, dictionary: $0.data())})
            completion(posts,nil)
            
            if let error = error {
                completion(nil,error)
            }
        }
    }
    
    static func fetchPostForUser(uid:String,completion:@escaping([Post]?,Error?)->()){
        let query = Constants.collection_posts.whereField("ownerUid", isEqualTo: uid)
        
        query.getDocuments { snapshot, error in
                guard let snapshot = snapshot else {
                    return
                }

            var posts = snapshot.documents.map({Post(postId: $0.documentID, dictionary: $0.data())})
            
            posts.sort { (firstPost, nextPost)->Bool in
                return firstPost.timestamp.seconds > nextPost.timestamp.seconds
            }
                completion(posts,nil)
                
                if let error = error {
                    completion(nil,error)
                }
        }
    }
}
