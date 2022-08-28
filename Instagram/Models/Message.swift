//
//  Message.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/08/2022.
//

import MessageKit
import Foundation

struct Message:MessageType{
    
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind

//    init(dictionary:[String:Any]){
//        self.messageId = dictionary["messageId"] as? String ?? ""
//        self.sentDate = dictionary["sentDate"] as? Date ?? Date()
//        self.kind = MessageKind(rawValue:dictionary["type"] as? Int ?? 0) ?? .text("")
//    }
}

extension MessageKind{
    var MessageKindString:String{
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributedText"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "linkPreview"
        case .custom(_):
            return "custom"
        }
    }
}
