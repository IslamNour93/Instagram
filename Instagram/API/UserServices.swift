//
//  UserServices.swift
//  Instagram
//
//  Created by Islam NourEldin on 02/08/2022.
//

import Foundation
import Firebase


typealias firebaseErrorCompletion = (Error?)->Void

class UserServices{
    
    static let shared = UserServices()
    
    private init(){
        
    }
    
    func fetchCurrentUser()->String{
        guard let uid = Auth.auth().currentUser?.uid else {fatalError()}
        return uid
    }
    
    func fetchUser(withUid uid:String,completion:@escaping(User?,Error?)->()){
        
        Constants.collection_users.document(uid).getDocument { snapShot, error in
            
            if let error = error {
                completion(nil,error)
            }else{
            guard let dictionary = snapShot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user,nil)
            }
        }
    }
    
    func fetchAllUsers(completion:@escaping([User])->()){
        Constants.collection_users.getDocuments { snapShot, error in
            if let error = error{
                print("DEBUG: Error in Fetching All users...:\(error)")
            }
            guard let snapShot = snapShot else {return}
            let users = snapShot.documents.map({User(dictionary: $0.data())})
            completion(users)
        }
    }
    
    func follow(uid:String,completion:@escaping firebaseErrorCompletion){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        Constants.collection_following.document(currentUid).collection("user-following").document(uid).setData([:]) { error in
    
            Constants.collection_followers.document(uid).collection("user-followers").document(currentUid).setData([:],completion: completion)
        }
    }
    
    func unfollow(uid: String,completion: @escaping firebaseErrorCompletion){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        Constants.collection_following.document(currentUid).collection("user-following").document(uid).delete { _ in
            Constants.collection_followers.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
    
    func checkIfUserIsfollowed(uid:String,completion:@escaping (Bool)->()){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        Constants.collection_following.document(currentUid).collection("user-following").document(uid).getDocument { snapshot, error in
            
            guard let isFollowed = snapshot?.exists else {return}
            
            completion(isFollowed)
        }
    }
    
    func checkUserStats(uid:String,completion:@escaping(UserStats)->()){
        
        Constants.collection_followers.document(uid).collection("user-followers").getDocuments { snapshot, error in
            guard let followers = snapshot?.documents.count else {return}
                
            Constants.collection_following.document(uid).collection("user-following").getDocuments { followingSnapshot, error in
                guard let following = followingSnapshot?.documents.count else{return}
                
                Constants.collection_posts.whereField("ownerUid", isEqualTo: uid).getDocuments { postsSnapshot, error in
                    guard let posts = postsSnapshot?.documents.count else{return}
                completion(UserStats(followers: followers, following: following, posts: posts))
                }
            }
        }
    }
}

