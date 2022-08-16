//
//  NotificationCell.swift
//  Instagram
//
//  Created by Islam NourEldin on 14/08/2022.
//

import UIKit
import SDWebImage

class NotificationCell: UITableViewCell {

    //MARK: - Properties
    static let identifier = "NotificationCell"
    
    var viewModel:NotificationViewModel?{
        didSet{
            configureCell()
        }
    }
    
    private let profileImageView:UIImageView = {
    let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60/2
        imageView.image = UIImage(named: "venom-7")
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
        addSubview(profileImageView)
        profileImageView.anchor(top:topAnchor,left: leftAnchor,paddingTop: 6,paddingLeft: 12,width:60,height:60)
        
        addSubview(followButton)
        followButton.centerY(inView: profileImageView)
        followButton.anchor(right:rightAnchor,paddingRight: 8,width: 100,height: 30)
        
        addSubview(postImageView)
        postImageView.centerY(inView: profileImageView)
        postImageView.anchor(right:rightAnchor,paddingRight: 8,width: 60,height: 60)
        
        addSubview(notificationLabel)
        notificationLabel.centerY(inView: profileImageView)
        notificationLabel.anchor(left:profileImageView.rightAnchor,right: followButton.leftAnchor,paddingLeft: 8,paddingRight: 8,height: 20)
        notificationLabel.numberOfLines = 0
    }
    
    private func configureCell(){
        guard let viewModel = viewModel else {return}
        postImageView.sd_setImage(with: viewModel.postImageUrl)
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationMessage
        postImageView.isHidden = viewModel.shouldHidePostImage
        followButton.isHidden = viewModel.shouldHideFollowButton
        
    }
    
    //MARK: - Actions
    
    @objc func didTapFollowButton(){
        print("did tap follow button")
    }
    
   

}
