//
//  MainTabbarViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 02/08/2022.
//

import Foundation


class MainTabbarViewModel{
    
    
    func getUser(completion:@escaping(User?,Error?)->()){
        UserServices.shared.fetchUsers { (user,error) in
            if let error = error {
                completion(nil,error)
            }else{
                completion(user,nil)
            }
        }
    }
}
