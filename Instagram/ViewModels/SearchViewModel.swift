//
//  SearchViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 04/08/2022.
//

import Foundation

class SearchViewModel{
    
    var users = [User]()
    
    init(){
        
        self.getAllUsers()
    }
    func getAllUsers(){
        UserServices.shared.fetchAllUsers { users in
            self.users = users
        }
    }
}
