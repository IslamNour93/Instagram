//
//  ChatsViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/08/2022.
//

import Foundation

class ChatsViewModel:NSObject{
    let user:User
    
    var fullname:String{
        return user.fullname
    }
    
    var username:String{
        return user.username
    }
    
    var profileImageUrl:URL?{
        return URL(string: user.profileImageUrl)
    }
    
    init(user:User){
        self.user = user
    }
}
