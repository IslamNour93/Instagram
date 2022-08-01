//
//  File.swift
//  Instagram
//
//  Created by Islam NourEldin on 31/07/2022.
//


import Firebase

class AuthenticationServices{
    
    static func registerUser(withUser user:UserModel,onSuccess:@escaping(Dictionary<String,Any>)->(),onFailure: @escaping (Error?)->()){
        guard let image = user.profileImage, let email = user.email, let password = user.password , let fullname = user.fullname, let username = user.username else {return}
        ImageUploader.uploadProfileImage(profileImage: image) { imageUrl in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error{
                    print("Debug: Failed to register User\(error.localizedDescription)")
                    return
                }
                guard let uid = result?.user.uid else {return}
                
                let data: [String:Any] = ["Email":email,
                                          "Fullname":fullname,
                                          "Username":username,
                                          "Uid": uid,
                                          "imageUrl":imageUrl]
                Firestore.firestore().collection("users").document(uid).setData(data,completion: onFailure)
                onSuccess(data)
            }
        }
    }
    
    static func logUserIn(email:String,password:String,completion:@escaping (AuthDataResult?,Error?)->() ){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
}
