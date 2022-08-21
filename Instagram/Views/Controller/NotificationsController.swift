//
//  NotificationsController.swift
//  Instagram
//
//  Created by Islam NourEldin on 14/08/2022.
//

import UIKit

class NotificationsController: UITableViewController {

    //MARK: - Properties
    private var notifications = [Notification]()
    private let refresher = UIRefreshControl()
    private let viewModel = UploadPostViewModel()
    private let mainTabbarViewModel = MainTabbarViewModel()
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchAllNotifications()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchAllNotifications()
        tableView.reloadData()
    }
    
    //MARK: - Helpers
    
    private func setupTableView(){
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        tableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(handleRefresher), for: .valueChanged)
    }
    
    private func fetchAllNotifications(){
        NotificationService.fetchAllNotifications {[weak self] notifications in
            guard let self = self else {return}
            if let notifications = notifications {
                self.notifications = notifications
                self.checkIfUserIsFollowed()
                self.refresher.endRefreshing()
            }else{
                print("DEBUG: Error in getting all Notifications")
            }
        }
    }
    
    private func checkIfUserIsFollowed(){
        
        notifications.forEach { notification in
            
            guard notification.type == .follow else {return}
            
            UserServices.shared.checkIfUserIsfollowed(uid: notification.uid) { [weak self] isFollowed in
                guard let self = self else {return}
                if let index = self.notifications.firstIndex(where: {$0.id == notification.id}){
                self.notifications[index].userIsFollowed = isFollowed
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Actions
    
    @objc private func handleRefresher(){
        notifications.removeAll()
        fetchAllNotifications()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notifications.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height*0.10
    }

    
    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTabbarViewModel.getUser(withUid: notifications[indexPath.row].uid) { user, error in
            guard let user = user else {return}
            let profileVC = ProfileController(user: user)
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

//MARK: - NotificationCellDelegate

extension NotificationsController:NotificationCellDelegate{
    
    func cell(_ forCell: NotificationCell, wantsToFollowUserWith uid: String) {
        
        UserServices.shared.follow(uid: uid) { error in
            forCell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ forCell:NotificationCell,wantsToUnfollowUserWith uid: String){
        UserServices.shared.unfollow(uid: uid) { error in
            forCell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ forCell: NotificationCell, wantsToShowPostWith postId: String) {
        print("did tap post image")
        viewModel.getPost(postId: postId) { post in
            let feedVC = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            feedVC.post = post
            self.navigationController?.pushViewController(feedVC, animated: true)
        }
    }
}
