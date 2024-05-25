//
//  SignInViewController.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 26/03/24.
//

import UIKit
import FirebaseAuth
import Firebase

class SignInViewController: UIViewController {
    
    
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
    
    
    lazy var email : UITextField = {
        let em = UITextField()
        em.borderStyle = .roundedRect
        em.placeholder = "Digite seu e-mail"
        em.keyboardType = .emailAddress
        em.autocapitalizationType = .none
        em.delegate = self
        em.returnKeyType = .next
        em.translatesAutoresizingMaskIntoConstraints = false
        return em
    }()
    
    lazy var password : UITextField = {
        let ps = UITextField()
        ps.borderStyle = .roundedRect
        ps.placeholder = "Digite sua senha"
        ps.returnKeyType = .done
        ps.autocapitalizationType = .none
        ps.isSecureTextEntry = true
        ps.textContentType = .oneTimeCode
        ps.delegate = self
        ps.translatesAutoresizingMaskIntoConstraints = false
        return ps
    }()
    
    lazy var login: LoadingButton = {
        let btn = LoadingButton()
        btn.backgroundColor = .systemOrange
        btn.title = "Entrar"
        btn.addTarget(self, action: #selector(sendDidTap))
        return btn
    }()
    
    lazy var register : UIButton = {
        let btn = UIButton()
        btn.setTitle("Primeiro acesso", for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.addTarget(self, action: #selector(registerDidTap), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    var viewModel : SignInViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Login"
        
        container.addSubview(logo)
        view.addSubview(scroll)
        scroll.addSubview(container)
        container.addSubview(register)
        container.addSubview(login)
        container.addSubview(email)
        container.addSubview(password)
        
        view.backgroundColor = .systemBackground
        
        
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
        
        let logoConstraints = [
            logo.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -100),
            logo.widthAnchor.constraint(equalToConstant: 200),
            logo.heightAnchor.constraint(equalToConstant: 200)
            
        ]
        
        let heigthConstraints = container.heightAnchor.constraint(equalTo: view.heightAnchor)
        heigthConstraints.priority = .defaultLow
        heigthConstraints.isActive = true
        
        let emailConstraints = [
            email.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            email.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            email.topAnchor.constraint(equalTo:logo.bottomAnchor, constant: -10.0),
            email.heightAnchor.constraint(equalToConstant: 50.0)
            
        ]
        let passwordConstraints = [
            password.leadingAnchor.constraint(equalTo: email.leadingAnchor),
            password.trailingAnchor.constraint(equalTo: email.trailingAnchor),
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10.0),
            password.heightAnchor.constraint(equalToConstant: 50.0)
            
        ]
        let loginConstraints = [
            login.leadingAnchor.constraint(equalTo: password.leadingAnchor),
            login.trailingAnchor.constraint(equalTo: password.trailingAnchor),
            login.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 30.0),
            login.heightAnchor.constraint(equalToConstant: 50.0)
            
        ]
        let registerConstraints = [
            register.leadingAnchor.constraint(equalTo: login.leadingAnchor),
            register.trailingAnchor.constraint(equalTo: login.trailingAnchor),
            register.topAnchor.constraint(equalTo: login.bottomAnchor, constant: 15.0),
            register.heightAnchor.constraint(equalToConstant: 50.0)
            
        ]
        NSLayoutConstraint.activate(registerConstraints)
        NSLayoutConstraint.activate(loginConstraints)
        NSLayoutConstraint.activate(emailConstraints)
        NSLayoutConstraint.activate(passwordConstraints)
        NSLayoutConstraint.activate(scrollConstraints)
        NSLayoutConstraint.activate(containerConstraints)
        NSLayoutConstraint.activate(logoConstraints)
        
        
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
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func sendDidTap(_ sender : UIButton) {
        guard let email = email.text,
              let password = password.text else {
            showError(message: "Por favor, preencha todos os campos.")
            return
        }
       
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let strongSelf = self else { return }
            
            guard let _ = authResult, error == nil else {
                print("falha ao logar o usuario com email : \(email)")
                return
            }
          
            if let user = Auth.auth().currentUser?.email{
                print("logado com o usuario \(String(describing: user))")
            }else {
                print("nao logou")
            }
  
            if let error = error {
                print("Erro ao fazer login:", error.localizedDescription)
                strongSelf.showError(message: "Erro ao fazer login")
            } else {
                print("Login bem-sucedido!")
                if let currentUser = Auth.auth().currentUser {
                    if currentUser.email == "danilotiago3@hotmail.com" {
                        strongSelf.viewModel?.goToHomeAdmin()
                    }else {
                        strongSelf.viewModel?.goToHomeUser()
                    }
                    
                }
             
            }
          
        }
            
        }
        
        @objc func registerDidTap(_ sender : UIButton){
            viewModel?.goToSignUp()
        }
        
}
    
    
    extension SignInViewController : UITextFieldDelegate {
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if (textField.returnKeyType == .done){
                view.endEditing(true)
                print("entrar!")
            }else {
                password.becomeFirstResponder()
            }
            
            return false
        }
        
        
    }
    

