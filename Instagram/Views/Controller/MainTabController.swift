//
//  MainTabController.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/07/2022.
//


import UIKit

class MainTabController: UITabBarController{
    
    //MARK: - Properties
    var mainTabbarViewModel = MainTabbarViewModel()
    var loginViewModel = LoginViewModel()
    var user: User?{
        didSet{
            guard let user = user else {
                return
            }
        configureViewControllers(user: user)
            print(user)
        }
    }
    //MARK: - LiveCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIslogged()
        fetchUser()
    }
    
    //MARK: - Getting Data From ViewModel
    
    func fetchUser(){
        mainTabbarViewModel.getUser { fetchedUser, error in
            if let error = error {
                print("Debug: Error Can't fetch User Data...\(error.localizedDescription)")
            }
            guard let fetchedUser = fetchedUser else {
                return
            }
            self.user = fetchedUser

        }
    }
    
    
    //MARK: - Helpers
    
    private func checkIfUserIslogged(){
        loginViewModel.checkIfUserIsLoggedIn {
            let vc = LoginController()
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    private func configureViewControllers(user:User?){
        guard let user = user else {
            return
        }
        view.backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "home_unselected")
                                                , selectedImage: UIImage(imageLiteralResourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        let search = templateNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "search_unselected"), selectedImage: UIImage(imageLiteralResourceName: "search_selected"), rootViewController: SearchController())
        let imageSelector = templateNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "plus_unselected"), selectedImage: UIImage(imageLiteralResourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        let notifications = templateNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "like_unselected"), selectedImage: UIImage(imageLiteralResourceName: "like_selected"), rootViewController: NotificationsController())
        let profile = templateNavigationController(unselectedImage: UIImage(imageLiteralResourceName: "profile_unselected"), selectedImage: UIImage(imageLiteralResourceName: "profile_selected"), rootViewController: ProfileController(user: user))
        
        viewControllers = [feed,search,imageSelector,notifications,profile]
        tabBar.isTranslucent = false
        tabBar.tintColor = .black
        
    }
    
    private func templateNavigationController(unselectedImage:UIImage,selectedImage:UIImage,rootViewController:UIViewController)->UINavigationController{
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedImage
        navigationController.navigationBar.tintColor = .black
        navigationController.navigationBar.isTranslucent = false
        return navigationController
    }
}

//MARK: - AuthenticationDelegate
extension MainTabController:AuthenticationDelegate{
    
    func authenticationDidComplete() {
        fetchUser()
        print("Protocol method has been called")
        self.dismiss(animated: true, completion: nil)
    }
}

