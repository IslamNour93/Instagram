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
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        NotificationService.fetchAllNotifications { notifications in
            if let notifications = notifications {
                self.notifications = notifications
                self.tableView.reloadData()
            }else{
                print("DEBUG: Error in getting all Notifications")
            }
            
        }
        
    }
    
    //MARK: - Helpers
    
    private func setupTableView(){
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notifications.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as! NotificationCell

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height*0.10
    }

    
    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
