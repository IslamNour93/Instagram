//
//  NotificationViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 15/08/2022.
//


import UIKit

class NotificationViewModel{
    
    let notification:Notification
    
    var profileImageUrl:URL?{
        return URL(string: notification.profileImageUrl)
    }
    
    var postImageUrl: URL?{
        return URL(string: notification.postImageUrl)
    }
    
    var notificationMessage:NSAttributedString{
        let username = notification.username
        let message = notification.type.notificationMessage
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: message, attributes: [.font:UIFont(name: "Optima", size: 15) ?? .systemFont(ofSize: 15)]))
        attributedText.append(NSMutableAttributedString(string: " 2m", attributes: [.font:UIFont(name: "Optima", size: 14) ?? .systemFont(ofSize: 14),.foregroundColor:UIColor.lightGray]))
            
           return attributedText
    }
    
    var shouldHidePostImage:Bool{
        return notification.type == .follow
    }
    
    var shouldHideFollowButton:Bool{
        return notification.type != .follow
    }
    
    init(notification:Notification){
        self.notification = notification
    }
}
