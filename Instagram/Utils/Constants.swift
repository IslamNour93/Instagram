//
//  Constants.swift
//  Instagram
//
//  Created by Islam NourEldin on 02/08/2022.
//

import Foundation
import Firebase

class Constants {
    
    static let collection_users = Firestore.firestore().collection("users")
    static let collection_followers = Firestore.firestore().collection("followers")
    static let collection_following = Firestore.firestore().collection("following")
    static let collection_posts = Firestore.firestore().collection("posts")
}

    
