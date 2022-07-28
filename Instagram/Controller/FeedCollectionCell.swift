//
//  FeedCollectionCell.swift
//  Instagram
//
//  Created by Islam NourEldin on 26/07/2022.
//

import UIKit

class FeedCollectionCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let profileImageView:UIImageView = {
    let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 40/2
        return imageView
    }()
    
    private lazy var userName: UIButton = {
        let userName = UIButton(type: .system)
        userName.setTitle("Venom", for: .normal)
        userName.setTitleColor(.label, for: .normal)
        userName.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        userName.addTarget(self, action: #selector(didTapUserNameButton), for: .touchUpInside)
        return userName
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.image = UIImage(named: "venom-7")
        profileImageView.anchor(top: topAnchor,left:leftAnchor,paddingTop: 12,paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        
        addSubview(userName)
        userName.centerY(inView: profileImageView,leftAnchor: profileImageView.rightAnchor,paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Actions
    
    @objc func didTapUserNameButton(){
        print("UserButton is tapped")
    }
}
