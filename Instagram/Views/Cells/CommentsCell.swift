//
//  CommentsCell.swift
//  Instagram
//
//  Created by Islam NourEldin on 09/08/2022.
//

import UIKit

class CommentsCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CommentsCell"
    
    private let userImageView:UIImageView = {
    let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50/2
        imageView.image = UIImage(named: "venom-7")
        return imageView
    }()
    
    private lazy var commentLabel:UILabel = {
        let label = UILabel()
        label.attributedText = attributeStatText(username: "Islam", comment: "Nice pic keep on..")
        return label
    }()
    
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addSubview(userImageView)
        userImageView.anchor(top:topAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 8,width: 50, height:50)
        addSubview(commentLabel)
        commentLabel.centerY(inView: userImageView)
        commentLabel.anchor(left:userImageView.rightAnchor,right:rightAnchor,paddingLeft: 8,paddingRight: 8)
        
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func attributeStatText(username:String,comment:String)->NSAttributedString{
         let attributedText = NSMutableAttributedString(string: "\(username)   ", attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
         attributedText.append(NSAttributedString(string: comment, attributes: [.font:UIFont.systemFont(ofSize: 14),.foregroundColor:UIColor.label]))
         
         return attributedText
     }
}
