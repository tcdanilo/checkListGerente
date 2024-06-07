//
//  SignUpViewController.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 27/03/24.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController : UIViewController{
    
    var viewModel : SignUpViewModel?
    
    
    let scroll: UIScrollView = {
        let sc = UIScrollView()
        sc.translatesAutoresizingMaskIntoConstraints = false
        
        return sc
    }()
    
    let container : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemBackground
        return v
    }()
    
    
    
    let logo : UIImageView = {
        let l = UIImageView()
        l.image = UIImage(named: "logo")
        l.contentMode = .scaleAspectFit
        l.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        l.clipsToBounds = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    private let nameTextField : UITextField = {
        let em = UITextField()
        em.borderStyle = .roundedRect
        em.placeholder = "Digite seu nome"
        em.autocapitalizationType = .none
        
        em.tag = 1
        em.returnKeyType = .next
        em.translatesAutoresizingMaskIntoConstraints = false
        return em
    }()
    private let emailTextField : UITextField = {
        let em = UITextField()
        em.borderStyle = .roundedRect
        em.placeholder = "Digite seu e-mail"
        em.keyboardType = .emailAddress
        em.autocapitalizationType = .none
        
        em.tag = 2
        em.returnKeyType = .next
        em.translatesAutoresizingMaskIntoConstraints = false
        return em
    }()
    
    
    private let passwordTextField : UITextField = {
        let ps = UITextField()
        ps.borderStyle = .roundedRect
        ps.placeholder = "Digite sua senha"
        ps.autocapitalizationType = .none
        ps.isSecureTextEntry = true
        ps.textContentType = .none
        ps.tag = 3
        ps.returnKeyType = .done
        ps.translatesAutoresizingMaskIntoConstraints = false
        return ps
    }()
    
    lazy var register : UIButton = {
        let r = UIButton()
        r.setTitle("Cadastrar", for: .normal)
        r.backgroundColor = .systemOrange
        r.addTarget(self, action: #selector(registerDidTap), for:.touchUpInside)
        r.translatesAutoresizingMaskIntoConstraints = false
        return r
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Cadastro"
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(scroll)
        scroll.addSubview(container)
        container.addSubview(nameTextField)
        container.addSubview(emailTextField)
        container.addSubview(passwordTextField)
        container.addSubview(register)
        container.addSubview(logo)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.delegate = self
        
        let scrollConstraints = [
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        let containerConstraints = [
            container.widthAnchor.constraint(equalTo: view.widthAnchor),
            container.topAnchor.constraint(equalTo: scroll.topAnchor),
            container.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 490.0)
        ]
        
        let heigthConstraints = container.heightAnchor.constraint(equalTo: view.heightAnchor)
        heigthConstraints.priority = .defaultLow
        heigthConstraints.isActive = true
        
        let logoConstraints = [
            logo.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -150),
            logo.widthAnchor.constraint(equalToConstant: 200),
            logo.heightAnchor.constraint(equalToConstant: 200)
            
        ]
        
        
        let nameConstrants = [
            nameTextField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            nameTextField.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 15.0),
            nameTextField.heightAnchor.constraint(equalToConstant: 50.0)
            
        ]
        
        
        let emailConstrants = [
            emailTextField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15.0),
            emailTextField.heightAnchor.constraint(equalToConstant: 50.0)
            
        ]
        let passwordConstrants = [
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15.0),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50.0)
            
        ]
        
        let registerConstraints = [
            register.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            register.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            register.topAnchor.constraint(equalTo:passwordTextField.bottomAnchor, constant: 30.0),
            register.heightAnchor.constraint(equalToConstant: 50.0)
        ]
        
        NSLayoutConstraint.activate(nameConstrants)
        NSLayoutConstraint.activate(emailConstrants)
        NSLayoutConstraint.activate(passwordConstrants)
        NSLayoutConstraint.activate(registerConstraints)
        NSLayoutConstraint.activate(logoConstraints)
        NSLayoutConstraint.activate(scrollConstraints)
        NSLayoutConstraint.activate(containerConstraints)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tap = UIGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ view: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc func onKeyboardNotification(_ notification : Notification){
        let visible = notification.name == UIResponder.keyboardWillShowNotification
        let keyboardFrame = visible
        ? UIResponder.keyboardFrameEndUserInfoKey
        : UIResponder.keyboardFrameBeginUserInfoKey
        
        if let keyboardSize = (notification.userInfo?[keyboardFrame] as? NSValue)?.cgRectValue {
            onKeyboardChanged(visible, height: keyboardSize.height)
        }
    }
    
    func onKeyboardChanged(_ visible : Bool , height : CGFloat) {
        if (!visible){
            scroll.contentInset = .zero
            scroll.scrollIndicatorInsets = .zero
        }else{
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: height, right: 0.0)
            scroll.contentInset = contentInsets
            scroll.scrollIndicatorInsets = contentInsets
        }
    }
    func alertingUserLoginError(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showSuccess(message: String) {
        let alert = UIAlertController(title: "Sucesso", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func registerDidTap() {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, password.count >= 6,
              let name = nameTextField.text, !name.isEmpty else {
            alertingUserLoginError(message: "Por favor, preencha todos os campos corretamente.")
            return
        }
        
        register.isEnabled = false
        register.alpha = 0.5
        
        PostService.shared.userExists(with: email) { [weak self] exists in
            guard let strongSelf = self else { return }
            
            if exists {
                strongSelf.alertingUserLoginError(message: "Uma conta com esse e-mail já existe.")
                strongSelf.register.isEnabled = true
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                strongSelf.register.isEnabled = true
                strongSelf.register.alpha = 1.0
                if let error = error as NSError? {
                    if let authErrorCode = AuthErrorCode.Code(rawValue: error.code){
                        switch authErrorCode {
                        case .networkError:
                            strongSelf.alertingUserLoginError(message: "Erro de rede. Verifique sua conexão.")
                        case .emailAlreadyInUse:
                            strongSelf.alertingUserLoginError(message: "E-mail já está em uso. Tente outro.")
                        case .weakPassword:
                            strongSelf.alertingUserLoginError(message: "Senha muito fraca. Tente uma mais forte.")
                        default:
                            strongSelf.alertingUserLoginError(message: "Erro ao criar conta: \(error.localizedDescription)")
                        }
                        return
                    }
                    
                    guard let user = authResult?.user else {
                        strongSelf.alertingUserLoginError(message: "Erro desconhecido ao criar usuário.")
                        return
                    }
                    
                    let appUser = AppUser(name: name, email: email)
                    PostService.shared.insertUser(with: appUser, uid: user.uid)
                    
                    let signInVC = SignInViewController()
                    strongSelf.navigationController?.pushViewController(signInVC, animated: true)
                    strongSelf.showSuccess(message: "Usuário cadastrado com sucesso!")
                }
            }
        }
    }
    
}
    extension SignUpViewController: UITextFieldDelegate {
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            if textField == nameTextField {
                emailTextField.becomeFirstResponder()
            }else if textField == emailTextField{
                passwordTextField.becomeFirstResponder()
            }else if textField == passwordTextField{
                registerDidTap()
            }
            
            return true

        }
    }
    
