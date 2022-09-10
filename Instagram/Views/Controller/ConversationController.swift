//
//  ConversationController.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/08/2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SDWebImage

class ConversationController: MessagesViewController {

    //MARK: - Properties
    
    private var userUid: String
    private var recipient: User?
    private var conversationID: String?
    
    var isNewChat = false
    
    private var messages = [Message]()
    
    private var messageSender: Sender?{
        

        return Sender(imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/instagram-59b38.appspot.com/o/profile_images%2FB87F627D-DC9C-4DB7-A1C1-B207889F9CA0?alt=media&token=097bf4f8-48cc-457c-923d-f839a3abbab8",
                      senderId: userUid,
                      displayName: "user.fullname")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    init(userUid:String,conversationID:String?){
        self.userUid = userUid
        self.conversationID = conversationID
        print(self.userUid)
        super.init(nibName: nil, bundle: nil)
        fetchUser(id:userUid)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listenForMessages(id: userUid)
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
    
    private func listenForMessages(id:String){
        ConversationService.fetchAllMessagesForConversation(withID: id) { messages in
            guard let messages = messages else {
                return
            }
            print("Messages fetched successfully...")
            
            self.messages = messages
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadDataAndKeepOffset()
                self.messagesCollectionView.scrollToLastItem()
            }  
        }
    }
    
    private func fetchUser(id:String){
        UserServices.shared.fetchUser(withUid: id) { user, error in
            guard let user = user else {
                return
            }
            self.recipient = user
        }
    }
}

extension ConversationController:MessagesDataSource{
    var currentSender: SenderType {
        if let sender = messageSender{
        return sender
        }
        fatalError("DEBUG: Sender is nil")
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
                                  messageId: userUid,
                                  sentDate: Date(),
                                  kind: .text(text))
            ConversationService.createNewConversation( withReciever: userUid, firstMessage: message) { success in
                if success{
                    print("message sent")
                    self.isNewChat = false
                }else{
                    print("Failed to send a message")
                }
            }
        }else{
            let newMessage = Message(sender: sender,
                                  messageId: userUid,
                                  sentDate: Date(),
                                  kind: .text(text))
            guard let conversationID = conversationID else {
                return
            }
            ConversationService.sendNewMessage(toConversation: conversationID, userUid: userUid, newMessage: newMessage) { success in
                if success{
                    print("New message is sent")
                    
                }else{
                    print("Failed to send a new message")
                }
            }
        }
    }
}
