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
    
    var viewModel = UploadPostViewModel()
    
    var mainTabbarViewModel = MainTabbarViewModel()
    
    var users = [User]()
    
    var post:Post?
    
    var posts = [Post](){
        didSet{
            print("Posts observer is called")
            collectionView.reloadData()
        }
    }
    

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getPostsData()
    }
    
    //MARK: - Actions
    
    @objc func handleLogout(){
        loginViewModel.signOut {
            self.checkIfUserIslogged()
        }
    }
    
    @objc func handleRefresher(){
        posts.removeAll()
        getPostsData()
    }
    
    //MARK: - Helpers
    
    private func configureUI(){
        collectionView.register(FeedCollectionCell.self, forCellWithReuseIdentifier: FeedCollectionCell.identifier)
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresher), for: .valueChanged)
        collectionView.refreshControl = refresher
        if post == nil{
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        }
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
    
    private func checkIfUserLikePost(){
        
        self.posts.forEach { post in
            viewModel.checkIfUserLikedPost(post: post) { didLike in
//                guard let self = self else {return}
                if let index = self.posts.firstIndex(where: {$0.postId == post.postId}){
                    self.posts[index].didLike = didLike
                }
            }
        }
        
    }
    
    private func getPostsData(){
        viewModel.getAllPosts {[weak self] posts, error in
            guard let self = self else {return}
            
            if let error = error {
                print("DEBUG: Error in fetcing posts..:\(error.localizedDescription)")
                return
            }
            
            if let posts = posts {
                self.posts = posts
                self.checkIfUserLikePost()
                self.collectionView.refreshControl?.endRefreshing()
                self.collectionView.reloadData()
                print("DEBUG: done refreshing")
            }
        }
    }
}
//MARK: - CollectionView DataSource

extension FeedController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionCell.identifier, for: indexPath) as! FeedCollectionCell
        cell.delegate = self
        if post == nil {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }else{
            if let post = post{
            cell.viewModel = PostViewModel(post: post)
            }
        }
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

//MARK: - FeedCollectionCellDelegate

extension FeedController:FeedCollectionCellDelegate{
    
    func cell(_ cell: FeedCollectionCell, wantsToNavigateTo userUid: String) {
        mainTabbarViewModel.getUser(withUid: userUid) { user, error in
            if let user = user {
                let vc = ProfileController(user: user)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func cell(_ cell: FeedCollectionCell, wantsToShowCommentsFor post: Post) {
        let vc = CommentsController(post: post)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func cell(_ cell: FeedCollectionCell,didLike post:Post){
        
        guard let tabbar = tabBarController as? MainTabController else {return}
        guard let user = tabbar.user else {return}
        
        cell.viewModel?.post.didLike.toggle()
         if post.didLike{
             print("Did tap unlike Post")
             viewModel.unlikePost(post: post) {
                 print("Did unlike Post")
                 cell.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
                 cell.likeButton.tintColor = .label
                 cell.viewModel?.post.likes = post.likes-1
                 self.collectionView.reloadData()
//                 print(cell.viewModel?.post.likes)
             }
             
         }else{
             print("Did tap like Post")
             viewModel.likePost(post: post) {
                 print("Did like Post")
                 cell.likeButton.tintColor = .red
                 cell.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
                 cell.viewModel?.post.likes = post.likes+1
//                 self.collectionView.reloadData()
                 NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .like, post: post)
//                 print(cell.viewModel?.post.likes)
             } 
         }
        
        
    }
    
}
