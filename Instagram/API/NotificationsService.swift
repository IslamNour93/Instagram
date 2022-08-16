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
        var notifications = [Notification]()
        Constants.collection_notifications.document(uid).collection("user-notifications").order(by: "timestamp", descending: true).addSnapshotListener { snaphotListner, error in
                guard let snapshotListner = snaphotListner else {return}
                
                snapshotListner.documentChanges.forEach { changes in
                    if changes.type == .added {
                        let data = changes.document.data()
                        let notification = Notification(dictionary: data)
                        notifications.append(notification)
                    }
                }
            completion(notifications)
        }
    }
}
