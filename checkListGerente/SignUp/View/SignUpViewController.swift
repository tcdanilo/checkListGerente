//
//  SignUpViewController.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 27/03/24.
//

import Foundation
import UIKit
import FirebaseAuth

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
    
    
    lazy var name : UITextField = {
        let em = UITextField()
        em.borderStyle = .roundedRect
        em.placeholder = "Digite seu nome"
        em.autocapitalizationType = .none
        em.delegate = self
        em.tag = 1
        em.returnKeyType = .next
        em.translatesAutoresizingMaskIntoConstraints = false
        return em
    }()
    lazy var email : UITextField = {
        let em = UITextField()
        em.borderStyle = .roundedRect
        em.placeholder = "Digite seu e-mail"
        em.keyboardType = .emailAddress
        em.autocapitalizationType = .none
        em.delegate = self
        em.tag = 2
        em.returnKeyType = .next
        em.translatesAutoresizingMaskIntoConstraints = false
        return em
    }()
    
    lazy var password : UITextField = {
        let ps = UITextField()
        ps.borderStyle = .roundedRect
        ps.placeholder = "Digite sua senha"
        ps.autocapitalizationType = .none
        ps.isSecureTextEntry = true
        ps.delegate = self
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
        container.addSubview(name)
        container.addSubview(email)
        container.addSubview(password)
        container.addSubview(register)
        container.addSubview(logo)
        
        
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
            name.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            name.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 15.0),
            name.heightAnchor.constraint(equalToConstant: 50.0)
            
        ]
        
        
        let emailConstrants = [
            email.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            email.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            email.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 15.0),
            email.heightAnchor.constraint(equalToConstant: 50.0)
            
        ]
        let passwordConstrants = [
            password.leadingAnchor.constraint(equalTo: email.leadingAnchor),
            password.trailingAnchor.constraint(equalTo: email.trailingAnchor),
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 15.0),
            password.heightAnchor.constraint(equalToConstant: 50.0)
            
        ]
        
        let registerConstraints = [
            register.leadingAnchor.constraint(equalTo: password.leadingAnchor),
            register.trailingAnchor.constraint(equalTo: password.trailingAnchor),
            register.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 30.0),
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
    func showError(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func showSucess(message : String){
        let alert = UIAlertController(title: "Sucesso", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
        present(alert,animated: true,completion: nil)
        
    }
    
    
    @objc func registerDidTap() {
        guard let email = email.text, let password = password.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
            
            guard let self = self else { return }
            
            if let error = error {
                print("Erro ao registrar usuário:", error.localizedDescription)
                showError(message: "Erro ao registrar usuário")
                
            } else {
                print("Usuário registrado com sucesso!")
                showSucess(message: "Usuário registrado com sucesso!")
                let SignInVC = SignInViewController()
                navigationController?.pushViewController(SignInVC, animated: true)
            }
            
        }
        
       
        
    }
}
    
    extension SignUpViewController: UITextFieldDelegate {
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if (textField.returnKeyType == .done){
                view.endEditing(true)
                print("save!")
                return false
            }
            let nextTag = textField.tag + 1
            let component = container.findViewByTag(tag: nextTag)
            
            if (component != nil) {
                component?.becomeFirstResponder()
            }else {
                view.endEditing(true)
            }
            return false
            
        }
    }
    
    extension UIView {
        func findViewByTag(tag : Int ) -> UIView? {
            for subview in subviews {
                if subview.tag == tag {
                    return subview
                }
            }
            return nil
        }
    }

