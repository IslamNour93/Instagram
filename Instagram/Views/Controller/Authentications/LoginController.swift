//
//  LoginController.swift
//  Instagram
//
//  Created by Islam NourEldin on 28/07/2022.
//

import UIKit

class LoginController: UIViewController {

    //MARK: - Properties
    var loginViewModel = LoginViewModel()
    
    var delegate: AuthenticationDelegate?
    
    let logoImage: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "Instagram_logo_white")
        
        return iv
    }()
    
    let emailTextField:UITextField = {
        let tf = UITextField()
        tf.customTextField(placeholder: "Email", height: 50)
        tf.keyboardType = .emailAddress
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.customTextField(placeholder: "Password", height: 50)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemPink
        button.setHeight(50)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let forgetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot your password?", secondPart: "Get help signing in.", fontSize: 16)
        button.addTarget(self, action: #selector(hadleForgetPassword), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account?", secondPart: "Sign Up", fontSize: 16)
        button.addTarget(self, action: #selector(navigateToRegisterScreen), for: .touchUpInside)
        return button
    }()
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientLayer()
        configureUI()
        configureNotificationObservers()
        updateForm()
    }
    
    //MARK: - Actions
    
    @objc func hadleForgetPassword(){
        let resetPassController = ResetPasswordController()
        resetPassController.delegate = self
        resetPassController.email = emailTextField.text
        navigationController?.pushViewController(resetPassController, animated: true)
    }
   @objc func navigateToRegisterScreen(){
        let regView = RegisterController()
        regView.delegate = delegate
        navigationController?.pushViewController(regView, animated: true)
    }
    
    @objc func textDidChange(sender:UITextField){
        if sender == emailTextField{
            loginViewModel.credential?.email = emailTextField.text
        }else{
            loginViewModel.credential?.password = passwordTextField.text
        }
        updateForm()
    }
    
    @objc func handleLogin(){
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        showLoader(true)
        loginViewModel.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Debug: Error in log user in..:\(error.localizedDescription)")
                self.showLoader(false)
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
            }
            if result != nil {
                self.showLoader(false)
                self.delegate?.authenticationDidComplete()
            }
        }
    }
    
    //MARK: - Helpers

    private func configureUI(){
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        view.addSubview(logoImage)
        logoImage.centerX(inView: view)
        logoImage.setDimensions(height: 80, width: 120)
        logoImage.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 32 )
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton,forgetPasswordButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.anchor(top:logoImage.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        view.addSubview(dontHaveAccoutButton)
        dontHaveAccoutButton.centerX(inView: view)
        dontHaveAccoutButton.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 16)
    }
}
    //MARK: - AdaptFormProtocol

extension LoginController:FormProtocol{
    
    func configureNotificationObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func updateForm() {
        loginButton.isEnabled = loginViewModel.formIsValid
        loginButton.setTitleColor(loginViewModel.buttonTitleColor, for: .normal)
        loginButton.backgroundColor = loginViewModel.buttonBackgroundColor
    }
}

//MARK: - ResetPasswordControllerDelegate

extension LoginController:ResetPasswordControllerDelegate{
    func controller(_ controllerDidResetPassword: ResetPasswordController) {
        navigationController?.popViewController(animated: true)
        showMessage(withTitle: "Reset Successfully", message: "An email has been sent to your inbox, Please check your inbox to reset your password.")
    }    
}

extension LoginController{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

