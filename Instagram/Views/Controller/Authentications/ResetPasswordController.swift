//
//  ResetPasswordController.swift
//  Instagram
//
//  Created by Islam NourEldin on 21/08/2022.
//

import UIKit


protocol ResetPasswordControllerDelegate:AnyObject{
    func controller(_ controllerDidResetPassword:ResetPasswordController)
}

class ResetPasswordController: UIViewController {
    
    //MARK: - Properties
    
    private let resetPasswordViewModel = ResetPasswordViewModel()
    
    weak var delegate: ResetPasswordControllerDelegate?
    
    var email:String?
    
    let emailTextField:UITextField = {
       let tv = UITextField()
        tv.customTextField(placeholder: "Email", height: 50)
        return tv
    }()
    
    let logoImage: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "Instagram_logo_white")
        
        return iv
    }()
    
    let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password", for: .normal)
        button.backgroundColor = .systemPink
        button.setHeight(50)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        return button
    }()
    
    let backButton:UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleBackToLogin), for: .touchUpInside)
        return button
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureUi()
        configureNotificationObservers()
        updateForm()
    }
    
    //MARK: - Actions
    
    @objc func textDidChange(sender:UITextField){
        
        if sender == emailTextField{
            resetPasswordViewModel.email = emailTextField.text
        }
        updateForm()
    }
    
    @objc func handleBackToLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleResetPassword(){
        self.showLoader(true)
        resetPasswordViewModel.resetPassword(withEmail: emailTextField.text!) {[weak self] error in
            guard let self = self else {return}
            if let error = error {
                self.showLoader(false)
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
            }else{
                self.delegate?.controller(self)
            }
        }
    }
    
    //MARK: - Helpers
    
    private func configureUi(){
        configureGradientLayer()
        emailTextField.text = email
        resetPasswordViewModel.email = email
        updateForm()
        view.addSubview(logoImage)
        logoImage.setDimensions(height: 80, width: 120)
        logoImage.centerX(inView: view)
        logoImage.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 64)

        let stack = UIStackView(arrangedSubviews: [emailTextField,resetButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.anchor(top:logoImage.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        emailTextField.delegate = self
        
        view.addSubview(backButton)
        backButton.anchor(top:view.safeAreaLayoutGuide.topAnchor,left:view.leftAnchor,paddingTop: 16,paddingLeft: 16)
    }
}

//MARK: - FormProtocol

extension ResetPasswordController:FormProtocol{
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func updateForm() {
        resetButton.isEnabled = resetPasswordViewModel.formIsValid
        resetButton.setTitleColor(resetPasswordViewModel.buttonTitleColor, for: .normal)
        resetButton.backgroundColor = resetPasswordViewModel.buttonBackgroundColor
    }
}

extension ResetPasswordController:UITextFieldDelegate{
    
}
