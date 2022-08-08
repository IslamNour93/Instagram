//
//  PostViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 08/08/2022.
//

import Foundation

class PostViewModel{
    
    private let post:Post
    
    var likes:String{
        if post.likes == 1{
            return "\(post.likes) like"
        }else{
            return "\(post.likes) likes"
        }
    }
    
    var caption:String{
        return post.caption
    }
    
    var imageUrl:URL?{
        return URL(string: post.imageUrl)
    }
    
    var ownerImageUrl:URL?{
        return URL(string: post.ownerImageUrl)
    }
    
    var ownerUsername:String{
        return post.ownerUsername
    }
    
    init(post:Post){
        self.post = post
    }
}
