//
//  ImageUploader.swift
//  Instagram
//
//  Created by Islam NourEldin on 31/07/2022.
//


import FirebaseStorage
import UIKit

class ImageUploader{
    
    static func uploadProfileImage(profileImage:UIImage,completion: @escaping (String)->()){
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.75) else {return}
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        ref.putData(imageData, metadata: nil) { metaData,error in
            if let error = error{
                print("Debug: Failed to upload image:\(error.localizedDescription)")
                return
            }
            ref.downloadURL { imageUrl, error in
                if let imageUrl = imageUrl {
                    completion(imageUrl.absoluteString)
                }else{
                    print("Debug:Error to get image URL")
                }
            }
        }

    }
}
