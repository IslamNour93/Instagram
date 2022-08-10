//
//  UploadPostController.swift
//  Instagram
//
//  Created by Islam NourEldin on 07/08/2022.
//

import UIKit

protocol UploadPostControllerDelegate:AnyObject{
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

class UploadPostController: UIViewController {

    
    //MARK: - Properties
    
    var postImage:UIImage?{
        didSet{
            postImageView.image = postImage
        }
    }
    
    var viewModel = UploadPostViewModel()
    
    var currentUser:User?
    
    weak var delegate:UploadPostControllerDelegate?
    
    private let postImageView:UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    private let captionTextView:CustomTextView = {
        let textView = CustomTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.placeholderText = "Enter caption"
        textView.placeholderShouldBeCentered = false
        return textView
    }()
    
    private let characterCounterLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.text = "0/200"
        return label
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       configureUI()
    }
    
    //MARK: - Helpers
    
    func checkMaxLength(textView:UITextView){
        if textView.text.count>200{
            textView.deleteBackward()
        }
    }
    
    private func configureUI(){
        view.backgroundColor = .systemBackground
        captionTextView.delegate = self
        navigationItem.title = "Upload post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapShare))
        view.addSubview(postImageView)
        postImageView.centerX(inView: view)
        let width = (view.frame.width)*0.5
        postImageView.setDimensions(height: width, width: width)
        postImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 8)
        
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top:postImageView.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 8,paddingLeft: 8,paddingRight: 8,height: 80)
        
        view.addSubview(characterCounterLabel)
        characterCounterLabel.anchor(bottom:captionTextView.bottomAnchor,right:captionTextView.rightAnchor,paddingBottom: -8,paddingRight: 8,width: 50,height: 20)
        
        
    }
    
    //MARK: - Actions
    
    @objc func didTapShare(){
        guard let postImage = postImage,let user = currentUser else {
            return
        }
        showLoader(true)
        viewModel.uploadPost(caption: captionTextView.text, image: postImage, user: user, onSuccess: {
            self.showLoader(false)
            self.delegate?.controllerDidFinishUploadingPost(self)
        }, onFailure: { error in
            print("DEBUG: Error in uploading post..:\(error.localizedDescription)")
            return
        })
    }
        
    
    @objc func didTapCancel(){
        self.delegate?.controllerDidFinishUploadingPost(self)
    }
}

extension UploadPostController:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView: textView)
        let counter = textView.text.count
        characterCounterLabel.text = "\(counter)/200"
    }
}


