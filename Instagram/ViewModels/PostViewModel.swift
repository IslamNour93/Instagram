//
//  PostViewModel.swift
//  Instagram
//
//  Created by Islam NourEldin on 08/08/2022.
//

import UIKit

class PostViewModel:NSObject{
    
    var post:Post
    
    var likes:String{
        if post.likes == 1{
            return "\(post.likes) like"
        }else{
            return "\(post.likes) likes"
        }
    }
    
    var timestampString:String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let timestampString = formatter.string(from: post.timestamp.dateValue(),to: Date()) ?? ""
        return timestampString + " ago"
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
    
    var likeButtonImage:UIImage?{
        let imageName = post.didLike ? "like_selected" : "like_unselected"
        
        return UIImage(named: imageName)
    }
    
    var likeButtonTintColor:UIColor{
        return post.didLike ? .red : .label
    }
    
    init(post:Post){
        self.post = post
    }
}
