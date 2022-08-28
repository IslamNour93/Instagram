//
//  NewConversationController.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/08/2022.
//

import UIKit

class NewConversationController: UIViewController {

    
    //MARK: - Propeties
    
    private var users = [User]()
    private var filteredUsers = [User]()
    private var hasFetched = false
    private var viewModel = SearchViewModel()
    private var chatsViewModel: ChatsViewModel?
    var completion: ((User)->())?
    
    private let tableView: UITableView={
        let tableView = UITableView()
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search For users.."
        return searchBar
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUi()
        setupDelegates()
    }
    
    //MARK: - Helpers
    
    private func configureUi(){
        navigationItem.title = "New Conversation"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(dismissController))
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        view.addSubview(searchBar)
        navigationController?.navigationBar.topItem?.titleView = searchBar
    }
    
    private func setupDelegates(){
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }

    //MARK: - Actions
    
    @objc func dismissController(){
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource

extension NewConversationController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
        cell.chatsViewModel = ChatsViewModel(user: filteredUsers[indexPath.row])
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NewConversationController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.row]
        
        dismiss(animated: false) {[weak self] in
            self?.completion?(user)
        }
    }
}

//MARK: - UISearchBarDelegate

extension NewConversationController:UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredUsers.removeAll()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filteredUsers.removeAll()
        showLoader(true)
        guard let text = searchBar.text , !text.replacingOccurrences(of: " ", with: "").isEmpty else {return}
        self.searchUsers(query: text)
    }
    
    private func searchUsers(query: String){
        if hasFetched{
            filterUsers(with: query)
        }else{
            viewModel.getAllUsers { [weak self] users in
                if let users = users {
                    self?.showLoader(false)
                    self?.users = users
                    self?.hasFetched = true
                    self?.filterUsers(with: query)
                }
            }
        }
    }
    
    private func filterUsers(with term:String){
        guard hasFetched else {return}
        
        let filteredUsers = users.filter({$0.fullname.contains(term)})
        self.filteredUsers = filteredUsers
        self.showLoader(false)
        self.updateUI()
    }
    
    private func updateUI(){
        
        if filteredUsers.isEmpty{
            tableView.isHidden = true
        }else{
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}
