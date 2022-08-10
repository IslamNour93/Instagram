//
//  MainTabController.swift
//  Instagram
//
//  Created by Islam NourEldin on 25/07/2022.
//


import UIKit
import YPImagePicker
import Firebase

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
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        mainTabbarViewModel.getUser(withUid: uid) { fetchedUser, error in
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
    
    private func showImagePicker(){
        
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.hidesBottomBar = false
        config.hidesStatusBar = false
        config.screens = [.library]
        config.library.maxNumberOfItems = 1
        
        let picker = YPImagePicker(configuration: config)
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: false, completion: nil)
        didFinishPicking(picker: picker)
    }
    
    private func didFinishPicking(picker:YPImagePicker){
        
        picker.didFinishPicking { [weak self] items, _ in
            
            guard let self = self else {return}
            
            picker.dismiss(animated: true) {
                guard let selectedPhoto = items.singlePhoto?.image else {return}
                let uploadPostVC = UploadPostController()
                uploadPostVC.currentUser = self.user
                uploadPostVC.postImage = selectedPhoto
                uploadPostVC.delegate = self
                let nav = UINavigationController(rootViewController: uploadPostVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav,animated: false)
            }
        }
    }
    
    private func configureViewControllers(user:User?){
        
        guard let user = user else {
            return
        }
        self.delegate = self
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

extension MainTabController:UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = viewControllers?.firstIndex(of: viewController) else {return}
        print(index)
        
        if index == 2{
            showImagePicker()
        }
    }
}
//MARK: - UploadPostDelegate

extension MainTabController:UploadPostControllerDelegate{
    
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        self.dismiss(animated: true, completion: nil)
        guard let feedNav = viewControllers?.first as? UINavigationController else {return}
        let feed = feedNav.viewControllers.first as? FeedController
        feed?.handleRefresher()
    }
   
}
