//
//  ProfileController.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/07/2022.
//

import UIKit

class ProfileController: UICollectionViewController{
    
    var user: User{
        didSet{
            collectionView.reloadData()
        }
    }
    
    var headerViewModel:ProfileHeaderViewModel!
    
    //MARK: - LiveCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCollectionView()
        getUserStats()
        checkIfUserIsFollowed()
    }
    init(user:User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        headerViewModel = ProfileHeaderViewModel(user: self.user)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getUserStats(){
        
        headerViewModel.getUserStats { [weak self] userStats in
            guard let self = self else {return}
            self.user.userStats = userStats
            print("followers:\(self.user.userStats.following),following:\(self.user.userStats.following)")
            self.collectionView.reloadData()
        }
    }
    
    func checkIfUserIsFollowed(){
        headerViewModel.checkIfUserIsFollowed { [weak self] isFollowed in
            guard let self = self else {return}
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
//MARK: - Helpers
    
    private func configureUI(){
        navigationItem.title = user.username
    }
    
    private func setupCollectionView(){
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
        
        collectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderView.identifier)
    }
}




//MARK: - CollectionView Datasource

extension ProfileController{
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        cell.backgroundColor = .gray
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderView.identifier, for: indexPath) as! ProfileHeaderView
        header.viewModel = ProfileHeaderViewModel(user: user)
        header.delegate = self
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
}

//MARK: - CollectionView DelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width-2)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        let height = view.frame.height
        return CGSize(width: width, height: height*0.3)
    }
}

extension ProfileController:ProfileHeaderProtocol{
    func header(_ profileHeader: ProfileHeaderView, didTapActionButtonFor user: User) {
        if user.isCurrentUser{
            
        }else if user.isFollowed{
            profileHeader.viewModel?.unfollowUser(onSuccess: {
                self.user.isFollowed = false
                self.collectionView.reloadData()
                print("Successfully Unfollowed User...")
                print(user.uid)
            })
            
            }else{
            profileHeader.viewModel?.followUser {
                
                print("Successfully followed user...")
                print(user.uid)
                self.user.isFollowed = true
                self.collectionView.reloadData()
            }
        }
    }
    
    
}
