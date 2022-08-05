//
//  ProfileHeaderProtocol.swift
//  Instagram
//
//  Created by Islam NourEldin on 05/08/2022.
//

import Foundation

protocol ProfileHeaderProtocol:AnyObject{
    
    func header(_ profileHeader:ProfileHeaderView, didTapActionButtonFor user: User)
}
