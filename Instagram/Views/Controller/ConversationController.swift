//
//  ConversationController.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/08/2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ConversationController: MessagesViewController {

    //MARK: - Properties
    
    var user: User
    
    var isNewChat = false
    
    private var messages = [Message]()
    
    private var messageSender: Sender?{
        guard let senderId = UserDefaults.standard.value(forKey: "currentUid") as? String else {
            return nil
        }
        return Sender(imageUrl: user.profileImageUrl,
                      senderId: senderId,
                      displayName: user.fullname)
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
          }
    
     init(user:User){
        self.user = user
         print(self.user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func setupDelegates(){
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.reloadData()
    }
}

extension ConversationController:MessagesDataSource{
    var currentSender: SenderType {
        guard let sender = messageSender else {
            return Sender(imageUrl: "", senderId: "", displayName: "")
        }
            return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    
}

extension ConversationController:MessagesDisplayDelegate{
    
}

extension ConversationController:MessagesLayoutDelegate{
    
}

extension ConversationController:InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty, let sender = messageSender else {
            return
        }
        
        if isNewChat{
            let message = Message(sender: sender,
                                  messageId: user.email,
                                  sentDate: Date(),
                                  kind: .text(text))
            ConversationService.createNewConversation(withRecieverId: user.uid, firstMessage: message) { success in
                if success{
                    print("message sent")
                }else{
                    print("Failed to send a message")
                }
            }
        }else{
            
        }
    }
}
