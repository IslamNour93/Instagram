//
//  SearchController.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/07/2022.
//

import UIKit

class SearchController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
    }
}
//MARK: - TableView DataSource
extension SearchController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height*0.1
    }
}
