//
//  NotificationsService.swift
//  Instagram
//
//  Created by Islam NourEldin on 14/08/2022.
//

import Firebase

class NotificationService{
    
static func uploadNotification(toUid uid:String,fromUser: User,type:NotificationType,post:Post? = nil){
        
    guard let currentUid = Auth.auth().currentUser?.uid else {return}
    guard uid != currentUid else {return}
    
    let docRef = Constants.collection_notifications.document(uid).collection("user-notifications").document()
    
    var data = ["id":docRef.documentID,
                "username":fromUser.username,
                "profileImageUrl":fromUser.profileImageUrl,
                "timestamp":Timestamp(date: Date()),
                "type":type.rawValue,
                "uid":fromUser.uid] as [String : Any]
    
    if let post = post {
        data["postImageUrl"] = post.imageUrl
        data["postId"] = post.postId
    }
    docRef.setData(data)
    }
    
    static func fetchAllNotifications(completion:@escaping ([Notification]?)->()){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Constants.collection_notifications.document(uid).collection("user-notifications").getDocuments { snapshot, error in
            if let error = error{
                print("DEBUG: Error in fetching all Notifications:\(error)")
            }
            guard let snapshot = snapshot else {return}
            let notifications = snapshot.documents.map({Notification(dictionary: $0.data())})
            completion(notifications)
        }
    }
}
