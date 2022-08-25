//
//  CommentsCell.swift
//  Instagram
//
//  Created by Islam NourEldin on 09/08/2022.
//

import UIKit
import SDWebImage

protocol CommentsCellDelegate:AnyObject{
    func cell(_ cell:CommentsCell,userID:String)
}

class CommentsCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CommentsCell"
    
    weak var delegate:CommentsCellDelegate?
    
    var viewModel:CommentViewModel?{
        didSet{
            configure()
        }
    }
    
    private let userImageView:UIImageView = {
    let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50/2
        
        return imageView
    }()
    
    private lazy var commentLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addSubview(userImageView)
        userImageView.anchor(top:topAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 8,width: 50, height:50)
        addSubview(commentLabel)
        commentLabel.centerY(inView: userImageView)
        commentLabel.anchor(left:userImageView.rightAnchor,right:rightAnchor,paddingLeft: 8,paddingRight: 8)
        commentLabel.numberOfLines = 0
        commentLabel.lineBreakMode = .byWordWrapping
        
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func attributeStatText(username:String,comment:String)->NSAttributedString{
         let attributedText = NSMutableAttributedString(string: "\(username)  ", attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
         attributedText.append(NSAttributedString(string: comment, attributes: [.font:UIFont.systemFont(ofSize: 14),.foregroundColor:UIColor.label]))
         
         return attributedText
     }
    
    private func configure(){
        guard let viewModel = viewModel else {
            return
        }

        userImageView.sd_setImage(with: viewModel.profileImageUrl)
        commentLabel.attributedText = attributeStatText(username: viewModel.username, comment: viewModel.commentText)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        userImageView.addGestureRecognizer(tapGR)
        userImageView.isUserInteractionEnabled = true
    }
    
    //MARK: Actions
    
    @objc func imageTapped(sender:UITapGestureRecognizer){
        if sender.state == .ended{
            print("user tapped image")
            guard let viewModel = viewModel else {
                return
            }
            delegate?.cell(self, userID: viewModel.userUid)
        }
    }
}


