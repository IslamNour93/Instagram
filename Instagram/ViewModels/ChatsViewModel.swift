//
//  ChatsViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/08/2022.
//

import Foundation

class ChatsViewModel:NSObject{
    let conversation:Conversation
    
    var fullname:String{
        return conversation.latestMessage.messageContent
    }
    
    var username:String{
        return conversation.username
    }
    
    var profileImageUrl:URL?{
        return URL(string: conversation.profileImageUrl)
    }
    
    init(conversation:Conversation){
        self.conversation = conversation
    }
}
