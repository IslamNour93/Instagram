//
//  FeedCollectionCell.swift
//  Instagram
//
//  Created by Islam NourEldin on 26/07/2022.
//

import UIKit
import SDWebImage

protocol FeedCollectionCellDelegate:AnyObject{
    func cell(_ cell: FeedCollectionCell,wantsToShowCommentsFor post:Post)
    func cell(_ cell: FeedCollectionCell,wantsToNavigateTo userUid:String)
    func cell(_ cell: FeedCollectionCell,didLike post:Post)
}


class FeedCollectionCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "feedCell"
    
    var viewModel:PostViewModel?{
        didSet{
            configure()
        }
    }
    
    weak var delegate:FeedCollectionCellDelegate?
    
    private lazy var profileImageView:UIImageView = {
    let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 40/2
        
        return imageView
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(didTapUserNameButton), for: .touchUpInside)
        return button
    }()
    
    private var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTapCommentsButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2"), for: .normal)
        button.tintColor = .label
        
        return button
    }()
    
    private var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .label
        return label
    }()
    
    private var captionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    
    private var postDateLabel: UILabel = {
        let label = UILabel()
        label.text = "25/12/2022"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor,left:leftAnchor,paddingTop: 12,paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        
        
        addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView,leftAnchor: profileImageView.rightAnchor,paddingLeft: 8)
        
        addSubview(postImageView)
        postImageView.anchor(top:profileImageView.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 8)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        configureActionButtons()
        
        addSubview(likesLabel)
        likesLabel.anchor(top:likeButton.bottomAnchor,left: leftAnchor,paddingTop: -4,paddingLeft: 8)
        
        addSubview(captionsLabel)
        captionsLabel.anchor(top:likesLabel.bottomAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 8)
        
        addSubview(postDateLabel)
        postDateLabel.anchor(top:captionsLabel.bottomAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 8)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    //MARK: - Actions
    
    @objc func didTapUserNameButton(){
        guard let viewModel = viewModel else {
            return
        }
        self.delegate?.cell(self, wantsToNavigateTo: viewModel.post.ownerUid)
    }
    
    @objc func didTapCommentsButton(){
        guard let viewModel = viewModel else {
            return
        }
        self.delegate?.cell(self, wantsToShowCommentsFor: viewModel.post)
    }
    
    @objc func didTapLikeButton(){
        
        guard let viewModel = viewModel else {
            return
        }
        self.delegate?.cell(self, didLike: viewModel.post)

    }
    
    //MARK: - Helpers
    
    private func configureActionButtons(){
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top:postImageView.bottomAnchor,left: leftAnchor,paddingTop: 8, paddingLeft: 8, width: 120,height: 50)
    }
    
    private func configure(){
        guard let viewModel = viewModel else {
            return
        }
        postImageView.sd_setImage(with: viewModel.imageUrl)
        captionsLabel.text = viewModel.caption
        usernameButton.setTitle(viewModel.ownerUsername, for: .normal)
        profileImageView.sd_setImage(with: viewModel.ownerImageUrl)
        likesLabel.text = viewModel.likes
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModel.likeButtonTintColor
        profileImageView.addGestureRecognizer(UIGestureRecognizer(target:self,action: #selector(didTapUserNameButton)))
        profileImageView.isUserInteractionEnabled = true
        postDateLabel.text = viewModel.timestampString
    }
    
}
