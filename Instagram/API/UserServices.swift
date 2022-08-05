//
//  UserServices.swift
//  Instagram
//
//  Created by Islam NourEldin on 02/08/2022.
//

import Foundation
import Firebase

class UserServices{
    
    static let shared = UserServices()
    
    typealias firebaseErrorCompletion = (Error?)->Void
        
    private init(){
        
    }
    
    func fetchUser(completion:@escaping(User?,Error?)->()){
        guard let uid = Auth.auth().currentUser?.uid else {return}
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
        
        Constants.collection_followers.document(currentUid).collection("user-followers").document(uid).setData([:]) { error in
    
            Constants.collection_following.document(uid).collection("user-following").document(currentUid).setData([:],completion: completion)
        }
    }
    
    func unfollow(uid: String,completion: @escaping firebaseErrorCompletion){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        Constants.collection_following.document(currentUid).collection("user-following").document(uid).delete { _ in
            Constants.collection_followers.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
}
