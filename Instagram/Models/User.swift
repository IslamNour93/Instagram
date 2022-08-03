//
//  User.swift
//  Instagram
//
//  Created by Islam NourEldin on 02/08/2022.
//

import Foundation
struct User{
    var email:String
    var fullname:String
    var username:String
    var profileImageUrl:String
    var uid:String
    
    init(dictionary:[String:Any]){
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
