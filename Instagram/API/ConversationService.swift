//
//  ConversationService.swift
//  Instagram
//
//  Created by Islam NourEldin on 27/08/2022.
//

import Firebase

class ConversationService{
    
    static func createNewConversation(withRecieverId recieverUid: String,firstMessage:Message,completion: @escaping (Bool)->()){
        
        guard let currentUid = UserDefaults.standard.value(forKey: "currentUid") as? String else {
            return
        }
        var message = ""

        switch firstMessage.kind{
            
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        
  
        let data: [String:Any] = ["messageId":"\(currentUid)+ \(Date())",
                                   "type":"\(firstMessage.kind)",
                                   "latestMessage":["message":message,
                                                    "sentDate":firstMessage.sentDate,
                                                    "isRead":false],
                                   "userUid":currentUid
                                    ]
        
        Constants.collection_conversations.document(currentUid).collection("message-sender").document(recieverUid).setData(data) { error in
            guard error == nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
}
