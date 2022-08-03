//
//  ProfileHeaderViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 03/08/2022.
//

import Foundation

class ProfileHeaderViewModel{
    let user: User
    
    var fullname:String{
        return user.fullname
    }
    var username:String{
        return user.fullname
    }
    var profileImageUrl:URL?{
        return URL(string: user.profileImageUrl)
    }
    
    init(user:User){
        self.user = user
    }
}
