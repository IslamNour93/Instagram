//
//  LoginViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 29/07/2022.
//

import UIKit

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
