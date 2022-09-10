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
    private var user:User?
    private var conversations = [Conversation](){
        didSet{
            tableView.reloadData()
        }
    }
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
        getAllConversations()
    }

    //MARK: - Helpers
    
    private func getAllConversations(){
        guard let currentUid = UserDefaults.standard.value(forKey: "currentUid") as? String else {
            return
        }
        print("fetching data...")
        ConversationService.getUserConversations(withUid: currentUid) { [weak self] conversations, error in
            if let conversations = conversations{
            self?.conversations = conversations
                print("fetched successfully")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                }
            }
        }
    }
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
    
    private func startNewChat(userUid:String){
        let chatVC = ConversationController(userUid: userUid, conversationID: nil)
        chatVC.isNewChat = true
        UserServices.shared.fetchUser(withUid: userUid) {[weak self] user, error in
            if let user = user {
                self?.user = user
                chatVC.title = user.username
            }
        }
        chatVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(chatVC, animated: false)
    }
    
    
    //MARK: - Actions
    
    @objc func handleNewConversation(){
        let neWConversationVC = NewConversationController()
        neWConversationVC.completion = { [weak self] userUid in

            self?.startNewChat(userUid: userUid)
        }
        let nav = UINavigationController(rootViewController: neWConversationVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false, completion: nil)
    }
}

//MARK: - UITableViewDataSource

extension ChatsController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
        cell.chatsViewModel = ChatsViewModel(conversation: conversations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height*0.1
    }
}

//MARK: - UITableViewDelegate

extension ChatsController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = conversations[indexPath.row]
        let conversationVC = ConversationController(userUid: model.userUid, conversationID: model.conversationID)
        UserServices.shared.fetchUser(withUid: model.userUid) {[weak self] user, error in
            if let user = user {
                self?.user = user
                conversationVC.title = user.username
            }
        }
        navigationController?.pushViewController(conversationVC, animated: false)
    }
}
