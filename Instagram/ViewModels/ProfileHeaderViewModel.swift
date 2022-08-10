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
    
    var numbersOfFollowers:NSAttributedString{
        return attributeStatText(value: user.userStats.followers, label: "followers")
    }
    
    var numbersOfFollowering:NSAttributedString{
        return attributeStatText(value: user.userStats.following, label: "following")
    }
    
    var numberOfPosts:NSAttributedString{
        return attributeStatText(value: user.userStats.posts, label: "posts")
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
    
    func checkIfUserIsFollowed(completion:@escaping(Bool)->()){
        UserServices.shared.checkIfUserIsfollowed(uid: user.uid) { isFollowed in

            completion(isFollowed)
        }
    }
    
    func getUserStats(completion:@escaping(UserStats)->()){
        UserServices.shared.checkUserStats(uid: user.uid) { userStats in
            completion(userStats)
        }
    }
    
    private func attributeStatText(value:Int,label:String)->NSAttributedString{
         let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
         attributedText.append(NSAttributedString(string: label, attributes: [.font:UIFont.systemFont(ofSize: 14),.foregroundColor:UIColor.lightGray]))
         
         return attributedText
     }
}
