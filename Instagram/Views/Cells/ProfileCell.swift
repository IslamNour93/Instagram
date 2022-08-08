//
//  ProfileCell.swift
//  Instagram
//
//  Created by Islam NourEldin on 01/08/2022.
//

import UIKit
import SDWebImage

class ProfileCell: UICollectionViewCell {
    
    static let identifier = "ProfileCell"
    
    var viewModel:PostViewModel?{
        didSet{
            configure()
        }
    }
    
    private let postImageView:UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        guard let viewModel = viewModel else {
            return
        }
        postImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
    }
}
