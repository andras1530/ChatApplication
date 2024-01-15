//
//  ViewController.swift
//  chatApplication
//
//  Created by Nagy Andras on 14.12.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    //Mark: - IBOutlets
    //labels
    @IBOutlet weak var emailLabelOutlet: UILabel!
    
    @IBOutlet weak var passwordLabelOutlet: UILabel!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    
    //textfields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatTextField: UITextField!
    
    //Buttons
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var resendEmailButtonOutlet: UIButton!
    
    
    //Views
    
    //Mark: - Vars
    var isLogin = true
    
    //Mark: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUIFor(login: true)
        setupTextFieldDeletages()
    }
    
    //Mark: IBActions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
        
    }
    
    //Mark: - Setup
    private func setupTextFieldDeletages() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        repeatTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        updatePlaceholderLabels(textfield: textfield)
    }
    
    //Mark: -Animation
    private func updateUIFor(login: Bool) {
        loginButtonOutlet.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        signUpButtonOutlet.setTitle(login ? "SignUp" : "Login", for: .normal)
        signUpLabel.text = login ? "Don't have an account?" : "Have an account?"
        
        UIView.animate(withDuration: 0.5) {
            self.repeatTextField.isHidden = login
            self.repeatPasswordLabel.isHidden = login
        }
    }
    
    
    
    private func updatePlaceholderLabels(textfield: UITextField) {
        switch textfield{
        case emailTextField:
            emailLabelOutlet.text = textfield.hasText ? "Email" : ""
        case passwordTextField:
            passwordLabelOutlet.text = textfield.hasText ? "Password" : ""
        default:
            repeatPasswordLabel.text = textfield.hasText ? "Repeat Password" : ""
        }
    }
    
    
}

