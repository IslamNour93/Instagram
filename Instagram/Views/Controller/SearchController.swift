//
//  SearchController.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/07/2022.
//

import UIKit

class SearchController: UITableViewController{
    
    //MARK: - Properties
    
    private var searchViewModel = SearchViewModel()
    private var users = [User]()
    private var filteredUsers = [User]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearchActive:Bool{
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: - Livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getUsers()
        configureSearchController()
    }
    //MARK: - Helpers
    
    func getUsers(){
        self.users = searchViewModel.users
        self.tableView.reloadData()
    }
    
    func setupTableView(){
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
    }
    
    private func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.hidesNavigationBarDuringPresentation = false
        if #available(iOS 11.0, *) {
                navigationItem.searchController = searchController
                navigationItem.hidesSearchBarWhenScrolling = false
            } else {
                tableView.tableHeaderView = searchController.searchBar
            }
        definesPresentationContext = false
        searchController.searchBar.placeholder = "Search"
        
    }
}

//MARK: - TableView DataSource
extension SearchController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isSearchActive ? filteredUsers.count : users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
        let user = isSearchActive ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = SearchCellViewModel(user: user)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height*0.1
    }
}
//MARK: - TableView Delegate
extension SearchController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = isSearchActive ? filteredUsers[indexPath.row] : users[indexPath.row]
        let userProfile = ProfileController(user: user)
        navigationController?.pushViewController(userProfile, animated: false)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        filteredUsers = users.filter({  $0.fullname.lowercased().contains(searchText) || $0.username.lowercased().contains(searchText)
        })
        self.tableView.reloadData()
    }
    
    
}
