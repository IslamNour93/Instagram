//
//  RegisterController.swift
//  Instagram
//
//  Created by Islam NourEldin on 29/07/2022.
//

import UIKit

class RegisterController: UIViewController {

    //MARK: - Properties
    
    var registerViewModel = RegisterViewModel()
    var loginViewModel = LoginViewModel()
    var profileImage:UIImage?
    weak var delegate: AuthenticationDelegate?
    
    private let selectProfilePhoto: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.setHeight(120)
        button.setWidth(120)
        button.addTarget(self, action: #selector(handleProfilePicSelect), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField:UITextField = {
        let tf = UITextField()
        tf.customTextField(placeholder: " Email", height: 50)
        tf.keyboardType = .emailAddress

        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.customTextField(placeholder: " Password", height: 50)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullNameTextField:UITextField = {
        let tf = UITextField()
        tf.customTextField(placeholder: " Fullname", height: 50)
        
        return tf
    }()
    
    private let usernameTextField:UITextField = {
        let tf = UITextField()
        tf.customTextField(placeholder: " Username", height: 50)
        
        return tf
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.setHeight(50)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignUserIn), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Already have an account?", secondPart: "Sign in", fontSize: 16)
        button.addTarget(self, action: #selector(navigteToLogin), for: .touchUpInside)
        return button
    }()
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientLayer()
        configureUI()
        configureDelegates()
        configureNotificationObservers()
        updateForm()
        
    }

    //MARK: - Actions
    
    @objc func textDidChange(sender:UITextField){
        
        if sender == emailTextField{
            registerViewModel.credential?.email = emailTextField.text
        }else if sender == passwordTextField{
            registerViewModel.credential?.password = passwordTextField.text
        }else if sender == fullNameTextField{
            registerViewModel.credential?.fullname = fullNameTextField.text
        }else if sender == usernameTextField{
            registerViewModel.credential?.username = usernameTextField.text
        }
        updateForm()
    }
    
    @objc func handleProfilePicSelect(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func handleSignUserIn(){
        let user = Credentials(email: emailTextField.text, password: passwordTextField.text, fullname: fullNameTextField.text, username: usernameTextField.text?.lowercased(), profileImage: profileImage)
        configureSelectedPhotoState()
        if profileImage != nil{
            showLoader(true)
        }
        registerViewModel.signup(credential: user) {
            print("Successfully registered a new user")
            guard let email = user.email, let password = user.password else {return}
            self.loginViewModel.signIn(withEmail: email, password: password) { result, error in
                DispatchQueue.main.async {
                    self.showLoader(false)
                    self.delegate?.authenticationDidComplete()
                }
            }
        } onFailure: { [weak self] error in
            guard let self = self else {return}
            if let error = error{
                self.showLoader(false)
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc func navigteToLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helpers
    
    private func configureUI(){
        view.addSubview(selectProfilePhoto)
        selectProfilePhoto.centerX(inView: view)
        selectProfilePhoto.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,fullNameTextField,usernameTextField,signupButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.anchor(top:selectProfilePhoto.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 50,paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(alreadyHaveAccoutButton)
        alreadyHaveAccoutButton.anchor(left:view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,paddingLeft: 32,paddingBottom: 16,paddingRight: 32)
    }
    
    private func configureDelegates(){
        emailTextField.delegate = self
        usernameTextField.delegate = self
        fullNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func configureSelectedPhotoState(){
        if profileImage == nil{
            showMessage(withTitle: "Error", message: "You should select a profile picture before you register.")
        }
    }
}

    //MARK: - AdaptFormProtocol
extension RegisterController:FormProtocol{
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func updateForm() {
        signupButton.isEnabled = registerViewModel.formIsValid
        signupButton.setTitleColor(registerViewModel.buttonTitleColor, for: .normal)
        signupButton.backgroundColor = registerViewModel.buttonBackgroundColor
    }
}

extension RegisterController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedPhoto = info[.editedImage] as? UIImage else{return}
        profileImage = selectedPhoto
        selectProfilePhoto.layer.cornerRadius = selectProfilePhoto.frame.width / 2
        selectProfilePhoto.layer.masksToBounds = true
        selectProfilePhoto.layer.borderColor = UIColor.systemPurple.cgColor
        selectProfilePhoto.layer.borderWidth = 1
        selectProfilePhoto.setImage(selectedPhoto.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: false)
    }
}

//MARK: - UITextFieldDelegate
extension RegisterController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
