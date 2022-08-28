//
//  SearchCell.swift
//  Instagram
//
//  Created by Islam NourEldin on 03/08/2022.
//

import UIKit
import SDWebImage

class SearchCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "searchCell"
    
    var viewModel:SearchCellViewModel?{
        didSet{
            configure()
        }
    }
    
    var chatsViewModel:ChatsViewModel?{
        didSet{
            configureChatsCell()
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
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Islam93"
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Islam NourEldin"
        return label
    }()
    
    
    //MARK: - Livecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier:String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    private func configureUI(){
        selectionStyle = .none
        addSubview(profileImageView)
        profileImageView.anchor(top:topAnchor,left: leftAnchor,paddingTop: 6,paddingLeft: 12,width:60,height:60)
        addSubview(usernameLabel)
        usernameLabel.anchor(top:profileImageView.topAnchor,left:profileImageView.rightAnchor,right: rightAnchor,paddingTop: 8,paddingLeft: 8,paddingRight: 12,height: 20)
        addSubview(fullnameLabel)
        fullnameLabel.anchor(top:usernameLabel.bottomAnchor,left:profileImageView.rightAnchor,right:rightAnchor,paddingTop: 8,paddingLeft: 8,paddingRight: 12,height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        guard let viewModel = viewModel else {
            return
        }
        fullnameLabel.text = viewModel.fullname
        usernameLabel.text = viewModel.username
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
    
    private func configureChatsCell(){
        guard let chatsViewModel = chatsViewModel else {
            return
        }
        fullnameLabel.text = chatsViewModel.fullname
        usernameLabel.text = chatsViewModel.username
        profileImageView.sd_setImage(with: chatsViewModel.profileImageUrl)
    }
}
