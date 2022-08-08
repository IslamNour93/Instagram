//
//  RegisterViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 29/07/2022.
//

import UIKit

class RegisterViewModel:NSObject,AuthenticationProtocol{
    
    var credential:Credentials?
    
    var formIsValid: Bool{
        return credential?.email?.isEmpty == false && credential?.password?.isEmpty == false && credential?.fullname?.isEmpty == false && credential?.username?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor{
        return formIsValid ? .systemPink : .systemPink.withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor{
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
    override init() {
        
        credential = Credentials()
    }
    
    func signup(credential:Credentials,onSucces:@escaping ()->(),onFailure: @escaping(String)->()){
        AuthenticationServices.registerUser(withCredential: credential) { data in
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
