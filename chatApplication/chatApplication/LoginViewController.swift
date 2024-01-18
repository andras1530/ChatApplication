//
//  ViewController.swift
//  chatApplication
//
//  Created by Nagy Andras on 14.12.2023.
//

import UIKit
import ProgressHUD

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
        setupBackgroundTap()
    }
    
    //Mark: IBActions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: isLogin ? "login" : "register") {
            isLogin ? loginUser() : registerUser()
        } else {
            ProgressHUD.failed("All fields are required")
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: "password") {
            resetPassword()
        } else {
            ProgressHUD.failed("Email is required.")
        }
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: "password") {
            resendVerificationEmail()
        } else {
            ProgressHUD.failed("Email is required.")
        }
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
    
    @objc func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap() {
        print("background tap")
        view.endEditing(false)
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
    
    //Mark: -Helpers
    private func isDataInputedFor(type: String) -> Bool {
        switch type {
            case "login":
                return emailTextField.text != "" && passwordTextField.text != ""
            case "registration":
                return emailTextField.text != "" && passwordTextField.text != "" && repeatTextField.text != ""
            default:
                return emailTextField.text != ""
        }
    }
    
    private func registerUser() {
        if passwordTextField.text! == repeatTextField.text! {
            FirebaseUserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) {
                (error) in if error == nil {
                    ProgressHUD.success("Verification email sent.")
                    self.resendEmailButtonOutlet.isHidden = false
                    
                } else {
                    ProgressHUD.failed(error!.localizedDescription)
                }
            }
        }else {
            ProgressHUD.failed("The Passwords don't match")
        }
    }
    
    private func loginUser() {
        FirebaseUserListener.shared.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) {
            (error, isEmailVerified) in
            
            if error == nil {
                if isEmailVerified {
                    self.goToApp()
                    
//                    print("user has logged in with email: ", User.currentUser?.email)
                }else {
                    ProgressHUD.failed("Please verifiy your email")
                    self.resendEmailButtonOutlet.isHidden = false
                }
            }else {
                ProgressHUD.failed(error!.localizedDescription)
            }
        }
    }
    
    private func resetPassword() {
        FirebaseUserListener.shared.resetPasswordFor(email: emailTextField.text!) {
            (error) in
            if error == nil {
                ProgressHUD.success("Reset link sent to email.")
            } else {
                ProgressHUD.failed(error!.localizedDescription)
            }
        }
    }
    
    private func resendVerificationEmail() {
        FirebaseUserListener.shared.resendVerificationEmail(email: emailTextField.text!) {
            (error) in
            if error == nil {
                ProgressHUD.success("New verification email sent.")
            } else {
                ProgressHUD.failed(error!.localizedDescription)
            }
            
        }}
    
    //Mark: - Navigation
    
    private func goToApp() {
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true,completion: nil)
    }
    
    
}

