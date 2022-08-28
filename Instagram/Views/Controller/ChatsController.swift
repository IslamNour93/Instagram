//
//  ChatsController.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/08/2022.
//

import UIKit

class ChatsController: UIViewController {

    //MARK: - Properties
    private var users = [User]()
    private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        return tableView
    }()
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserServices.shared.fetchUserFollowers { users in
            guard let users = users else {
                return
            }
            self.users = users
            self.tableView.reloadData()
        }
    }

    //MARK: - Helpers
    
    private func setupTableView(){
        title = "Chats"
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(handleNewConversation))
    }
    
    private func startNewChat(user:User){
        let chatVC = ConversationController(user: user)
        chatVC.isNewChat = true
        chatVC.title = user.fullname
        chatVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(chatVC, animated: false)
    }
    
    //MARK: - Actions
    
    @objc func handleNewConversation(){
        let neWConversationVC = NewConversationController()
        neWConversationVC.completion = { [weak self] user in
            self?.startNewChat(user: user)
        }
        let nav = UINavigationController(rootViewController: neWConversationVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false, completion: nil)
    }
}

//MARK: - UITableViewDataSource

extension ChatsController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
        cell.chatsViewModel = ChatsViewModel(user: users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height*0.1
    }
    
}

//MARK: - UITableViewDelegate

extension ChatsController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationVC = ConversationController(user: users[indexPath.row])
        navigationController?.pushViewController(conversationVC, animated: false)
    }
}
