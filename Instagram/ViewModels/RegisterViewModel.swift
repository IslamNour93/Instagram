//
//  RegisterViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 29/07/2022.
//

import UIKit

class RegisterViewModel:NSObject,AuthenticationProtocol{
    
    var user:UserModel?
    var formIsValid: Bool{
        return user?.email?.isEmpty == false && user?.password?.isEmpty == false && user?.fullname?.isEmpty == false && user?.username?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor{
        return formIsValid ? .systemPink : .systemPink.withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor{
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
    override init() {
        
        user = UserModel()
    }
    
    func signup(user:UserModel,onSucces:@escaping ()->(),onFailure: @escaping(String)->()){
        AuthenticationServices.registerUser(withUser: user) { data in
            DispatchQueue.main.async {
                onSucces()
            }
            
        } onFailure: { error in
            guard let error = error else{return}
            print(error.localizedDescription)
            onFailure("Failed to register a user")
        }

    }
}
