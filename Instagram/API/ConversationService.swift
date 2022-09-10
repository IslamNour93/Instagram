//
//  ConversationService.swift
//  Instagram
//
//  Created by Islam NourEldin on 27/08/2022.
//

import Firebase
import Foundation

class ConversationService{

    
    static func createNewConversation(withReciever userUid:String,firstMessage:Message,completion: @escaping (Bool)->()){
        
        UserServices.shared.fetchUser(withUid: userUid) { user, error in
            guard let user = user else {
                return
            }
            guard let currentUid = UserDefaults.standard.value(forKey: "currentUid") as? String,let currentUserName = UserDefaults.standard.value(forKey: "currentUserName") as? String,let currentUserImage = UserDefaults.standard.value(forKey: "currentUserProfileImage") as? String else {
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
            
            let senderData: [String:Any] = ["conversationID":"\(currentUid)",
                                            "latestMessage":["content":message,
                                                             "sentDate":firstMessage.sentDate,
                                                             "isRead":false],
                                            "username":"\(user.username)",
                                            "userUid":user.uid,
                                            "profileImageUrl":user.profileImageUrl]
            
            let recipientData: [String:Any] = ["conversationID":"\(user.uid)",
                                               "latestMessage":["content":message,
                                                                "sentDate":firstMessage.sentDate,
                                                                "isRead":false],
                                               "userUid":currentUid,
                                               "username":"\(currentUserName)",
                                               "profileImageUrl":currentUserImage
                                                 ]
            /// update sender data
            Constants.collection_users.document(currentUid).collection("conversations").document("\(user.uid)").setData(senderData) { error in
            
                    guard error == nil else {
                        completion(false)
                        return
                    }
                self.finishCreatingMessage(withReciever: user, documentPath: user.uid, username:currentUserName,conversationID: "\(currentUid)", firstMessage: firstMessage)
                completion(true)
            }
            
            ///update recipient data
            Constants.collection_users.document(user.uid).collection("conversations").document("\(currentUid)").setData(recipientData) { error in
                self.finishCreatingMessage(withReciever: user, documentPath: currentUid, username: user.username, conversationID: "\(user.uid)", firstMessage: firstMessage)
            }
        }
        
    }
    
    private static func finishCreatingMessage(withReciever user:User,documentPath:String,username:String,conversationID:String,firstMessage:Message){
        
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
        
        let messageData: [String:Any] = ["messageId":"\(currentUid)+\(Date())",
                                         "type":"\(firstMessage.kind.MessageKindString)",
                                         "content":message,
                                         "sentDate":firstMessage.sentDate,
                                         "isRead":false,
                                         "userUid":user.uid,
                                         "username":"\(username)"]
        
        Constants.collection_users.document(documentPath).collection("conversations").document(conversationID).collection("messages").document().setData(messageData)
    }
    
    static func getUserConversations(withUid currentUid:String,completion:@escaping([Conversation]?,Error?)->()){
        
        Constants.collection_users.document(currentUid).collection("conversations").addSnapshotListener { snapShot, error in
            var conversations = [Conversation]()
            guard let snapshot = snapShot  else {
                completion(nil,error)
                return
            }
            print("Fetching data from firebase..")
            snapshot.documentChanges.forEach { change in
                if change.type == .added{
                    let data = change.document.data()
                    print(data)
                    let conversation = Conversation(dictionary: data)

                    conversations.append(conversation)
                    print("fetched successfully:\(conversations.count)")
                }
            }
            completion(conversations, nil)
        }
    }
    
    static func fetchAllMessagesForConversation(withID documentPath: String,completion:@escaping([Message]?)->()){
        
        guard let currentUid = UserDefaults.standard.value(forKey: "currentUid") as? String else {
            return
        }
        
        Constants.collection_users.document(currentUid).collection("conversations").document(documentPath).collection("messages").order(by: "sentDate", descending: false).addSnapshotListener { snapshot, error in
            
            guard let changes = snapshot?.documentChanges else {
                return
            }
            
            let messages:[Message] = changes.compactMap { change in
                    print(change.document.data())
                    let data = change.document.data()
                    let userUid = data["userUid"] as? String ?? ""
                    let content = data["content"] as? String ?? ""
                    let date = data["sentDate"] as? Date ?? Date()
                    let username = data["username"] as? String ?? ""
                    let isread = data["isRead"] as? Bool ?? false
                    let type = data["type"] as? String ?? ""
                    let id = data["messageId"] as? String ?? ""
                    
                    let sender = Sender(imageUrl: "",
                                        senderId: userUid,
                                        displayName: username)
                    return Message(sender: sender, messageId: id, sentDate: date, kind: .text(content))
            }
            completion(messages)
        }
    }
   
    
    static func sendNewMessage(toConversation conversationID:String,userUid: String,newMessage:Message,completion: @escaping (Bool)->()){
        
        guard let currentUid = UserDefaults.standard.value(forKey: "currentUid") as? String,
              let currentName = UserDefaults.standard.value(forKey: "currentUserName") as? String else {
            return
        }
        
        /// send a new message to messages
               
        var message = ""

                switch newMessage.kind{
                    
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
                
                let messageData: [String:Any] = ["messageId":"\(currentUid)+\(Date())",
                                                 "type":"\(newMessage.kind.MessageKindString)",
                                                 "content":message,
                                                 "sentDate":newMessage.sentDate,
                                                 "isRead":false,
                                                 "userUid":userUid,
                                                 "username":"\(currentName)"]
        
       
        Constants.collection_users.document(currentUid).collection("conversations").document(userUid).collection("messages").document().setData(messageData,merge: false)
            completion(true)
        
    }
    
}
