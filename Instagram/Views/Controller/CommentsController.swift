//
//  CommentsController.swift
//  Instagram
//
//  Created by Islam NourEldin on 09/08/2022.
//

import UIKit


class CommentsController: UICollectionViewController {

    var post:Post
    
    var comments = [Comment]()
    
    var viewModel: CommentViewModel?
    
    var mainTabViewModel = MainTabbarViewModel()    
    
    private lazy var inputCommentTextView:CommentInputAccessoriesView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width , height: 80)
        let commentView = CommentInputAccessoriesView(frame: frame)
        commentView.delegate = self
        return commentView
    }()
    
    override var inputAccessoryView: UIView?{
        get {return inputCommentTextView}
    }
    
    override var canBecomeFirstResponder: Bool{
      return true
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        getPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    init(post:Post){
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func setupCollectionView(){
        navigationItem.title = "Comments"
        self.collectionView!.register(CommentsCell.self, forCellWithReuseIdentifier: CommentsCell.reuseIdentifier)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.keyboardDismissMode = .interactive
    }
    
    private func getPosts(){
       
        CommentService.fetchComments(postId: post.postId) { comments in
            self.comments = comments
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return comments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentsCell.reuseIdentifier, for: indexPath) as! CommentsCell
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        cell.delegate = self
        return cell
    }
}
    
    //MARK: - CollectionViewFlowLayoutDelegate
extension CommentsController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = view.frame.height
        return CGSize(width: width, height: height*0.10)
    }

}

    

    // MARK: UICollectionViewDelegate
extension CommentsController{
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension CommentsController:CommentInputAccessoriesViewDelegate{
    func inputView(_ inputView: CommentInputAccessoriesView, commentText: String) {
        guard let tabBar = self.tabBarController as? MainTabController else {return}
        
        guard let user = tabBar.user else {return}
            
        showLoader(true)
        
        CommentService.postComment(forpost: commentText, postId: post.postId , user: user, completion: {
            error in
            if let error = error{
                print("DEBUG: Can't post comment..\(error.localizedDescription)")
            }else{
                DispatchQueue.main.async {
                    self.showLoader(false)
                }
            }
        })
        
        NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .comment, post: post)
        
        inputView.clearCommentText()
    }
}

//MARK: - CommentsCellDelegate

extension CommentsController:CommentsCellDelegate{
    func cell(_ cell: CommentsCell, userID: String) {
        mainTabViewModel.getUser(withUid: userID) { user, error in
            guard let user = user else {
                return
            }
            let vc = ProfileController(user: user)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
