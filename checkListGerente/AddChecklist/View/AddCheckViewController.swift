//
//  AddCheckViewController.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 23/04/24.
//

import Foundation
import UIKit


class AddCheckViewController: UIViewController {
    
    
    var viewModel : AddChecklistViewModel?
    var users : [AppUser] = []
    
    
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
    
    
    lazy var titleChecklist : UITextField = {
        let ed = UITextField()
        ed.borderStyle = .roundedRect
        ed.placeholder = "Digite o título"
        ed.delegate = self
        ed.tag = 1
        ed.returnKeyType = .next
        ed.translatesAutoresizingMaskIntoConstraints = false
        return ed
    }()
    
    
    let userPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    
    lazy var addButton : UIButton = {
        let r = UIButton()
        r.setTitle("Criar Checklist", for: .normal)
        r.backgroundColor = .systemOrange
        r.translatesAutoresizingMaskIntoConstraints = false
        r.addTarget(self, action: #selector(addTextField), for: .touchUpInside)
        return r
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Novo checklist"
        view.backgroundColor = .systemBackground
        
        view.addSubview(scroll)
        scroll.addSubview(container)
        container.addSubview(titleChecklist)
        container.addSubview(addButton)
        container.addSubview(userPicker)
        userPicker.dataSource = self
        userPicker.delegate = self
        fetchUsers()
        
        
        
        
        
        
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
        
        
        
        let titleChecklistConstraints = [
            titleChecklist.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleChecklist.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            titleChecklist.topAnchor.constraint(equalTo: container.bottomAnchor,constant: -450),
            titleChecklist.heightAnchor.constraint(equalToConstant: 50.0)
        ]
        
        
        let userPickerConstraints = [
            userPicker.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 50.0),
            userPicker.trailingAnchor.constraint(equalTo:container.trailingAnchor, constant: -50.0),
            userPicker.topAnchor.constraint(equalTo: titleChecklist.bottomAnchor, constant: 15.0),
            userPicker.heightAnchor.constraint(equalToConstant: 50.0)
            
        ]
        
        
        
        let addButtonConstraints = [
            addButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo:container.trailingAnchor),
            addButton.topAnchor.constraint(equalTo: userPicker.bottomAnchor, constant: 20.0),
            addButton.heightAnchor.constraint(equalToConstant: 50.0)
        ]
        
        
        
        NSLayoutConstraint.activate(titleChecklistConstraints)
        NSLayoutConstraint.activate(userPickerConstraints)
        NSLayoutConstraint.activate(addButtonConstraints)
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
    
    func fetchUsers() {
        PostService.shared.fetchAllUsers { users in
            DispatchQueue.main.async {
                if users.isEmpty {
                    print("Nenhum usuário encontrado.")
                } else {
                    self.users = users
                    self.userPicker.reloadAllComponents()
                    print("Usuários carregados: \(users.map { $0.name })")
                }
            }
        }
    }
    @objc func addTextField() {
        guard let checklistText = titleChecklist.text else {return}
        guard let assignedUser = getSelectedUser() else {return}
        
        PostService.shared.uploadChecklistItem(text: checklistText, assignedUser: assignedUser) { (err, ref) in
            self.titleChecklist.text = ""
            if let navController = self.navigationController {
                for viewController in navController.viewControllers {
                    if let feedVC = viewController as? FeedViewController {
                        feedVC.fetchItems()
                        navController.popToViewController(feedVC, animated: true)
                        break
                    }
                    
                }
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    
    func getSelectedUser() -> AppUser? {
            let selectedIndex = userPicker.selectedRow(inComponent: 0)
            guard selectedIndex < users.count else { return nil }
            return users[selectedIndex]
        }
            
}

extension AddCheckViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Apenas uma coluna para os usuários
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(users.count)
        return users.count // Número de usuários obtidos do Firebase
        
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Retorna o nome do usuário para exibir no UIPickerView
        return users[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row < users.count else {
                    print("Índice selecionado fora do intervalo.")
                    return
                }
                let selectedUser = users[row]
                print("Usuário selecionado: \(selectedUser.name)")
            }
}




        extension AddCheckViewController: UITextFieldDelegate {
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if (textField.returnKeyType == .done){
                view.endEditing(true)
                print("save!")
                return false
            }
            let nextTag = textField.tag + 1
            let component = container.findViewByTag2(tag: nextTag)
            
            if (component != nil) {
                component?.becomeFirstResponder()
            }else {
                view.endEditing(true)
            }
            return false
            
        }
    }

extension UIView {
    func findViewByTag2(tag : Int ) -> UIView? {
        for subview in subviews {
            if subview.tag == tag {
                return subview
            }
        }
        return nil
    }
    
    
}
   
    

