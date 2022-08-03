//
//  FeedController.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/07/2022.
//

import UIKit



class FeedController: UICollectionViewController{
    
    //MARK: - Properties
    var loginViewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Actions
    
    @objc func handleLogout(){
        loginViewModel.signOut {
            self.checkIfUserIslogged()
        }
    }
    
    //MARK: - Helpers
    
    private func configureUI(){
        collectionView.register(FeedCollectionCell.self, forCellWithReuseIdentifier: FeedCollectionCell.identifier)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    private func checkIfUserIslogged(){
        loginViewModel.checkIfUserIsLoggedIn {
            let vc = LoginController()
            vc.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
   
}
//MARK: - CollectionView DataSource

extension FeedController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionCell.identifier, for: indexPath) as! FeedCollectionCell

        return cell
    }
}
//MARK: - CollectionView DelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        return CGSize(width: width, height: width*1.5)
    }
}
