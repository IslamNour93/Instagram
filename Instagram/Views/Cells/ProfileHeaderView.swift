//
//  ProfileHeaderView.swift
//  Instagram
//
//  Created by Islam NourEldin on 01/08/2022.
//

import UIKit
import SDWebImage

class ProfileHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    
    static let identifier = "profileHeaderView"
    
    var viewModel:ProfileHeaderViewModel?{
        didSet{
            configureUI()
        }
    }
    
    weak var delegate: ProfileHeaderProtocol?
    private let profileImageView:UIImageView = {
    let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 80/2
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var editProfile:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 3
        button.setHeight(30)
        button.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var posts:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        label.attributedText = attributeStatText(value: 8, label: "Posts")
        return label
    }()
    private lazy var followers:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        label.attributedText = attributeStatText(value: 1, label: "Followers")
        return label
    }()
    private lazy var following:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        label.attributedText = attributeStatText(value: 1, label: "Following")
        return label
    }()
    private let topSeperatorView:UIView = {
        let topView = UIView()
        topView.backgroundColor = .gray
        return topView
    }()
    
    private let bottomSeperatorView:UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .gray
        return bottomView
    }()
    
    let gridButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        return button
    }()
    
    let listButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        return button
    }()
    
    let bookmarkButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor,left:leftAnchor,paddingTop: 12,paddingLeft: 12)
        profileImageView.setDimensions(height: 80, width: 80)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 12,paddingLeft: 12,paddingRight: 12)
        addSubview(editProfile)
        editProfile.anchor(top:nameLabel.bottomAnchor,left: leftAnchor,right:rightAnchor,paddingTop: 12,paddingLeft: 24,paddingRight: 24)
        addSubview(topSeperatorView)
        topSeperatorView.anchor(top:editProfile.bottomAnchor,left:leftAnchor,right: rightAnchor,paddingTop: 8,height: 0.5)
        addSubview(bottomSeperatorView)
        bottomSeperatorView.anchor(left:leftAnchor,bottom:bottomAnchor,right: rightAnchor,height: 0.5)
        
        let stackView = UIStackView(arrangedSubviews: [posts,followers,following])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.centerY(inView: profileImageView)
        stackView.anchor(left:profileImageView.rightAnchor,right:rightAnchor,paddingLeft: 12,paddingRight: 12,height: 50)
        
        let buttonStack = UIStackView(arrangedSubviews: [gridButton,listButton,bookmarkButton])
        buttonStack.distribution = .fillEqually
        addSubview(buttonStack)
        buttonStack.anchor(top:topSeperatorView.bottomAnchor,left:leftAnchor,right:rightAnchor,paddingTop: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
   private func attributeStatText(value:Int,label:String)->NSAttributedString{
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font:UIFont.systemFont(ofSize: 14),.foregroundColor:UIColor.lightGray]))
        
        return attributedText
    }
    
    private func configureUI(){
        guard let viewModel = viewModel else {
            return
        }
        nameLabel.text = viewModel.fullname
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        editProfile.setTitle(viewModel.followButtonTitle, for: .normal)
        editProfile.backgroundColor = viewModel.followButtonBackGround
        editProfile.setTitleColor(viewModel.buttonFontColor, for: .normal)
    }
    
    //MARK: - Actions
    
    @objc func didTapFollowButton(){
        guard let viewModel = viewModel else {
            return
        }
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
}
