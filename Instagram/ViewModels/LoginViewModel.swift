//
//  LoginViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 29/07/2022.
//

import UIKit
import Firebase

protocol AuthenticationProtocol{
    var formIsValid:Bool{get}
    var buttonBackgroundColor:UIColor{get}
    var buttonTitleColor:UIColor{get}
}

class LoginViewModel:NSObject{
    var user: UserModel?
    
    override init() {
        user = UserModel()
    }
    
    func signIn(withEmail email:String,password:String,onCompletion:@escaping(AuthDataResult?,Error?)->()){
        AuthenticationServices.logUserIn(email: email, password: password) { result, error in
            
            if let error = error {
                onCompletion(nil,error)
                print("Couldn't log User in..:\(error.localizedDescription)")
            }
            onCompletion(result,nil)
        }
    }
    func checkIfUserIsLoggedIn(completion:@escaping ()->()){
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func signOut(completion:@escaping()->()){
        do{
        try Auth.auth().signOut()
            DispatchQueue.main.async {
                completion()
            }
        }catch{
            print("Couldn't sign out..")
        }
    }
}

extension LoginViewModel:AuthenticationProtocol{
    
    var formIsValid:Bool{
        return user?.email?.isEmpty == false && user?.password?.isEmpty == false
    }
    
    var buttonBackgroundColor:UIColor{
        return formIsValid ? .systemPink : .systemPink.withAlphaComponent(0.5)
    }
    
    var buttonTitleColor:UIColor{
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
}
