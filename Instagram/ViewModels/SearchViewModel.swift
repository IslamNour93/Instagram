//
//  SearchViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 04/08/2022.
//

import Foundation

class SearchViewModel:NSObject{
    
   
    func getAllUsers(completion:@escaping([User]?)->()){
        UserServices.shared.fetchAllUsers { users in
            completion(users)
        }
    }
}
