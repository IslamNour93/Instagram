//
//  NotificationViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 15/08/2022.
//


import UIKit

struct NotificationViewModel{
    
    var notification:Notification
    
    var profileImageUrl:URL?{
        return URL(string: notification.profileImageUrl)
    }
    
    var postImageUrl: URL?{
        return URL(string: notification.postImageUrl)
    }
    
    var timestampString:String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notification.timestamp.dateValue(),to: Date()) ?? ""
    }
    
    var notificationMessage:NSAttributedString{
        let username = notification.username
        let message = notification.type.notificationMessage
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: message, attributes: [.font:UIFont(name: "Optima", size: 15) ?? .systemFont(ofSize: 15)]))
        attributedText.append(NSMutableAttributedString(string: " \(timestampString) ago", attributes: [.font:UIFont(name: "Optima", size: 14) ?? .systemFont(ofSize: 14),.foregroundColor:UIColor.lightGray]))
            
           return attributedText
    }
    
    var shouldHidePostImage:Bool{
        return notification.type == .follow
    }
    
    var shouldHideFollowButton:Bool{
        return notification.type != .follow
    }
    
    var followButtonText:String{
        return notification.userIsFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackGroundColor:UIColor{
        return notification.userIsFollowed ? .systemBackground : .systemBlue
    }
    
    var followButtonTitleColor:UIColor{
        return notification.userIsFollowed ? .label : .white
    }
    
    init(notification:Notification){
        
        self.notification = notification
    }
    
}
