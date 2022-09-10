//
//  Conversation.swift
//  Instagram
//
//  Created by Islam NourEldin on 29/08/2022.
//

import Foundation

struct Conversation{
    var conversationID: String
    var username: String
    var profileImageUrl: String
    var latestMessage :Latestmessage
    var userUid: String
    init(dictionary:[String:Any]){
        self.conversationID = dictionary["conversationID"] as? String ?? ""
        self.latestMessage = Latestmessage(dictionary: dictionary["latestMessage"] as? [String:Any] ?? [:])
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.userUid = dictionary["userUid"] as? String ?? ""
    }
}

struct Latestmessage{
    var messageContent: String
    var isRead:Bool
    var sentDate: Date
    
    init(dictionary:[String:Any]){
        self.messageContent = dictionary["content"] as? String ?? ""
        self.isRead = dictionary["isRead"] as? Bool ?? false
        self.sentDate = dictionary["sentDate"] as? Date ?? Date()
    }
}
