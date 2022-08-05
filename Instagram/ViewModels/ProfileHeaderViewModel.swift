//
//  ProfileHeaderViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 03/08/2022.
//

import Foundation
import Firebase
import UIKit

class ProfileHeaderViewModel{
    var user: User
    
    var fullname:String{
        return user.fullname
    }
    var username:String{
        return user.fullname
    }
    var profileImageUrl:URL?{
        return URL(string: user.profileImageUrl)
    }
    
    var followButtonTitle:String{
        
        if user.isCurrentUser{
            return "Edit profile"
        }else{
          return  user.isFollowed ? "Following" : "Follow"
        }
    }
    
    var followButtonBackGround:UIColor{
        return user.isCurrentUser ? .white : .blue
    }
    
    var buttonFontColor:UIColor{
        return user.isCurrentUser ? .black : .white
    }
    
    init(user:User){
        self.user = user
    }
    
    func followUser(onSuccess:@escaping()->()){
        
        UserServices.shared.follow(uid: user.uid) { error in
            onSuccess()
        }
    }
    
    func unfollowUser(onSuccess:@escaping()->()){
        UserServices.shared.unfollow(uid: user.uid) { error in
            onSuccess()
        }
    }
    
}
