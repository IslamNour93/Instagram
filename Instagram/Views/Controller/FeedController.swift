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
    
    var uploadPostViewModel = UploadPostViewModel()
    
    var mainTabbarViewModel = MainTabbarViewModel()
    
    var users = [User]()
    
    var post:Post?{
        didSet{
            print("Post observer is called")
            self.collectionView.reloadData()
        }
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if post != nil{
            checkIfUserLikePost()
        }
    }
    
    //MARK: - Actions
    
    @objc func handleLogout(){
        loginViewModel.signOut {
            self.checkIfUserIslogged()
        }
    }
    
    @objc func handleRefresher(){
        posts.removeAll()
        if post != nil{
        checkIfUserLikePost()
        }
        getPostsData()
    }
    
    @objc func hadnleMessageButton(){
        let chatsVC = ChatsController()
        navigationController?.pushViewController(chatsVC, animated: true)
    }
    
    //MARK: - Helpers
    
    private func configureUI(){
        navigationItem.title = "Feed"
        collectionView.register(FeedCollectionCell.self, forCellWithReuseIdentifier: FeedCollectionCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresher), for: .valueChanged)
        collectionView.refreshControl = refresher
        if post == nil{
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
            navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(named: "send2"), style: .plain, target: self, action: #selector(hadnleMessageButton))
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
        
        if let post = post{
            uploadPostViewModel.checkIfUserLikedPost(post: post) { isLiked in
                self.post?.didLike = isLiked
            }
        }else{
        self.posts.forEach { post in
            uploadPostViewModel.checkIfUserLikedPost(post: post) {[weak self] didLike in
                guard let self = self else {return}
                if let index = self.posts.firstIndex(where: {$0.postId == post.postId}){
                    self.posts[index].didLike = didLike
                }
            }
        }
    }
}
    
    private func getPostsData(){
        uploadPostViewModel.fetchFeedPosts {[weak self] posts in
            guard let self = self else {return}
            if let posts = posts {
                self.posts = posts
                self.checkIfUserLikePost()
                self.collectionView.refreshControl?.endRefreshing()
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
             uploadPostViewModel.unlikePost(post: post) { _ in
                 print("Did unlike Post")
                 cell.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
                 cell.likeButton.tintColor = .label
                 cell.viewModel?.post.likes = post.likes-1
                 cell.configure()
             }
             
         }else{
             print("Did tap like Post")
             uploadPostViewModel.likePost(post: post) { _ in
                 print("Did like Post")
                 cell.likeButton.tintColor = .red
                 cell.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
                 cell.viewModel?.post.likes = post.likes+1
                 cell.configure()
                 NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .like, post: post)
             } 
         }
        
        
    }
    
}
