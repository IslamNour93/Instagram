//
//  Notification.swift
//  Instagram
//
//  Created by Islam NourEldin on 14/08/2022.
//

import Firebase
import CloudKit


enum NotificationType:Int{
    case like
    case comment
    case follow
    
    var notificationMessage:String{
        switch self {
        case .like:
          return  " liked your post."
        case .comment:
          return " commented on your post."
        case .follow:
          return " start following you."
        }
    }
}
struct Notification{
    let id: String
    let username: String
    let profileImageUrl: String
    let postImageUrl: String
    let type: NotificationType
    let timestamp:Timestamp
    
    init(dictionary:[String:Any]){
        self.id = dictionary["id"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
