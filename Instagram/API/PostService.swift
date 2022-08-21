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
           let docRef = Constants.collection_posts.addDocument(data: data,completion: completion)
            self.updateUserFeedAfterPost(postId: docRef.documentID)
        }
    }
    
    static func fetchPost(withPostId postId: String,completion:@escaping (Post)->()){
        
        Constants.collection_posts.document(postId).getDocument { snapshot, error in
            guard let snapshot = snapshot , let postData = snapshot.data() else  { return }
            let post = Post(postId: postId, dictionary: postData)
            completion(post)
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
    
    static func fetchPostsForUser(uid:String,completion:@escaping([Post]?,Error?)->()){
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
    
    static func updateFeedAfterFollowing(user:User,isFollowed:Bool,completion:@escaping firebaseErrorCompletion){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let query = Constants.collection_posts.whereField("ownerUid", isEqualTo: user.uid)
        
        query.getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {return}
            let docIds = documents.map({$0.documentID})
            
            docIds.forEach { id in
                print("DEBUG:\(id)")
                if isFollowed{
                    Constants.collection_users.document(uid).collection("user-feed").document(id).setData([:],completion: completion)
                }else{
                    Constants.collection_users.document(uid).collection("user-feed").document(id).delete(completion: completion)
                }
            }
        }
    }
    
    static func fetchFeedPosts(completion:@escaping([Post]?)->()){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var posts = [Post]()
        
        Constants.collection_users.document(uid).collection("user-feed").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            
            documents.forEach { document in
                fetchPost(withPostId: document.documentID) { post in
                    posts.append(post)
                    posts.sort { (firstPost, nextPost)->Bool in
                        return firstPost.timestamp.seconds > nextPost.timestamp.seconds
                    }
                    completion(posts)
                }
            }
        }
    }
    
    private static func updateUserFeedAfterPost(postId:String){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Constants.collection_followers.document(uid).collection("user-followers").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            
            documents.forEach { document in
                Constants.collection_users.document(document.documentID).collection("user-feed").document(postId).setData([:])
            }
            Constants.collection_users.document(uid).collection("user-feed").document(postId).setData([:])
        }
    }
}
