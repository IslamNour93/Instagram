//
//  SearchCellViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 04/08/2022.
//

import Foundation

class SearchCellViewModel{
    
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
