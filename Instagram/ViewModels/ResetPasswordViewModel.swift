//
//  ResetPasswordViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 21/08/2022.
//

import UIKit

class ResetPasswordViewModel:AuthenticationProtocol{
    
    var email:String?
    
    var formIsValid: Bool{return email?.isEmpty == false}
    
    var buttonBackgroundColor: UIColor{return formIsValid ? .systemPink : .systemPink.withAlphaComponent(0.5)}
    
    var buttonTitleColor: UIColor{return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)}
    
    init(){
        email = ""
    }
    
    func resetPassword(withEmail email: String, completion:@escaping (Error?)->()){
    AuthenticationServices.resetPassword(withEmail: email, completion: completion)
    }
}


