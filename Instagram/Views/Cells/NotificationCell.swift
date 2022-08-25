//
//  NotificationCell.swift
//  Instagram
//
//  Created by Islam NourEldin on 14/08/2022.
//

import UIKit
import SDWebImage

protocol NotificationCellDelegate:AnyObject{
    func cell(_ forCell:NotificationCell,wantsToFollowUserWith uid: String)
    func cell(_ forCell:NotificationCell,wantsToUnfollowUserWith uid: String)
    func cell(_ forCell:NotificationCell,wantsToShowPostWith postId:String)
}
class NotificationCell: UITableViewCell {

    //MARK: - Properties
    static let identifier = "NotificationCell"
    
    var viewModel:NotificationViewModel?{
        didSet{
            configureCell()
        }
    }
    
    weak var delegate:NotificationCellDelegate?
    
    private let profileImageView:UIImageView = {
    let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60/2
        return imageView
    }()
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var followButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBackground
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 3
        button.setTitle("loading", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var postImageView:UIImageView = {
    let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        
        return imageView
    }()
    
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    //MARK: - Helpers
    
    private func configureUI(){
        selectionStyle = .none
        addSubview(profileImageView)
        profileImageView.centerY(inView: self)
        profileImageView.anchor(left: leftAnchor,paddingLeft: 12,width:60,height:60)
        contentView.addSubview(postImageView)
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right:rightAnchor,paddingRight: 8,width: 88,height: 30)
        
        
        postImageView.centerY(inView: self)
        postImageView.anchor(right:rightAnchor,paddingRight: 8,width: 70,height: 70)
        
        
        contentView.addSubview(notificationLabel)
        notificationLabel.centerY(inView: profileImageView,
                                  leftAnchor: profileImageView.rightAnchor,
                                  paddingLeft: 8)
        notificationLabel.anchor(right:followButton.leftAnchor,
                                 paddingRight: 4)
    }
    
    private func configureCell(){
        guard let viewModel = viewModel else {return}
        postImageView.sd_setImage(with: viewModel.postImageUrl)
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationMessage
        postImageView.isHidden = viewModel.shouldHidePostImage
        followButton.isHidden = viewModel.shouldHideFollowButton
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.setTitleColor(viewModel.followButtonTitleColor, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBackGroundColor
        let tap = UIGestureRecognizer(target: self, action: #selector(handleTapPostImage))
        postImageView.addGestureRecognizer(tap)
        postImageView.isUserInteractionEnabled = true
    }
    
    //MARK: - Actions
    
    @objc func handleTapPostImage(){
        print("did tap post image")
        guard let viewModel = viewModel else {return}
       
        delegate?.cell(self, wantsToShowPostWith: viewModel.notification.postId)
      
    }
    
    
    @objc func didTapFollowButton(){
        guard let viewModel = viewModel else {
            return
        }
        
        if viewModel.notification.userIsFollowed{
            
            delegate?.cell(self, wantsToUnfollowUserWith: viewModel.notification.uid)
            
        }else{
            delegate?.cell(self, wantsToFollowUserWith: viewModel.notification.uid)
                
        }
    }
    
}
