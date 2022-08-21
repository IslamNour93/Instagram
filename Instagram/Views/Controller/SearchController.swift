//
//  SearchController.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/07/2022.
//

import UIKit

class SearchController: UIViewController{
    
    //MARK: - Properties
    
    private var searchViewModel = SearchViewModel()
    private var users = [User]()
    private var posts = [Post]()
    private var filteredUsers = [User]()
    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = UploadPostViewModel()
    private var isSearchActive:Bool{
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let tableView:UITableView={
        let tableView = UITableView()
        return tableView
    }()
    
    private let collectionView:UICollectionView={
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: SearchController.createLayout())
        return collectionView
    }()
    
    //MARK: - Livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUi()
        getUsers()
        getPosts()
        configureSearchController()
    }
    
    //MARK: - FetchingData
    
    func getUsers(){
        self.users = searchViewModel.users
        self.tableView.reloadData()
    }
    
    func getPosts(){
        viewModel.getAllPosts { posts, error in
            if let posts = posts {
                self.posts = posts
                self.collectionView.reloadData()
            }
        }
    }
    
    
    //MARK: - Helpers
        
    func configureUi(){
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
    }
    
    private func configureSearchController(){
        searchController.searchBar.delegate = self
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
    
    static func createLayout()->UICollectionViewCompositionalLayout{
        //Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let verticalStackItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)))
        verticalStackItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        //Group
        
        let verticalStackGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)),
            subitem: verticalStackItem,
            count: 2)
        
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(3/5)), subitems: [item,verticalStackGroup])
        
        //Sections
        let section = NSCollectionLayoutSection(group: group)
        //Return
        return UICollectionViewCompositionalLayout(section: section)
    }
}

//MARK: - TableViewDataSource
extension SearchController:UITableViewDataSource{
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isSearchActive ? filteredUsers.count : users.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
        let user = isSearchActive ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = SearchCellViewModel(user: user)
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height*0.1
    }
}
//MARK: - TableViewDelegate
extension SearchController:UITableViewDelegate{
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

//MARK: - CollectionViewDataSource

extension SearchController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:ProfileCell.identifier, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        
        return cell
    }
}

//MARK: - CollectionViewDelegate

extension SearchController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedVc = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        feedVc.post = posts[indexPath.row]
        navigationController?.pushViewController(feedVc, animated: true)
    }
}


//MARK: - UISearchBarDelegate

extension SearchController:UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        searchBar.showsCancelButton = true
        collectionView.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        tableView.isHidden = true
        collectionView.isHidden = false
    }
}
