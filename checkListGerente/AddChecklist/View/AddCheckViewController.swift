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
    
    lazy var userAssigned: UITextField = {
        let ed = UITextField()
        ed.borderStyle = .roundedRect
        ed.placeholder = "Digite a quem vai atribuir"
        ed.delegate = self
        ed.tag = 2
        ed.returnKeyType = .next
        ed.translatesAutoresizingMaskIntoConstraints = false
        return ed
    }()
   
    
    
   
    

    
   
    
    lazy var addButton : UIButton = {
        let r = UIButton()
        r.setTitle("Adicionar Pergunta", for: .normal)
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
        container.addSubview(userAssigned)
     
        container.addSubview(addButton)
   
        
        
        //    container.addSubview(createChecklist)
        
        
        
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
        
        
        let userAssignedConstrants = [
            userAssigned.leadingAnchor.constraint(equalTo: titleChecklist.leadingAnchor),
            userAssigned.trailingAnchor.constraint(equalTo:titleChecklist.trailingAnchor),
            userAssigned.topAnchor.constraint(equalTo: titleChecklist.bottomAnchor, constant: 15.0),
            userAssigned.heightAnchor.constraint(equalToConstant: 50.0)
            
        ]
       
        
        
        let addButtonConstraints = [
            addButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo:container.trailingAnchor),
            addButton.topAnchor.constraint(equalTo: userAssigned.bottomAnchor, constant: 20.0),
            addButton.heightAnchor.constraint(equalToConstant: 50.0)
        ]
        
        //        let createChecklistConstraints = [
        //            createChecklist.leadingAnchor.constraint(equalTo: store.leadingAnchor),
        //            createChecklist.trailingAnchor.constraint(equalTo: store.trailingAnchor),
        //            createChecklist.topAnchor.constraint(equalTo: store.bottomAnchor, constant: 30.0),
        //            createChecklist.heightAnchor.constraint(equalToConstant: 50.0)
        //        ]
        
        NSLayoutConstraint.activate(titleChecklistConstraints)
        NSLayoutConstraint.activate(userAssignedConstrants)
    
        NSLayoutConstraint.activate(addButtonConstraints)
       
        // NSLayoutConstraint.activate(createChecklistConstraints)
        
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
    @objc func addTextField() {
        guard let checklistText = titleChecklist.text else {return}
        PostService.shared.uploadChecklistItem(text: checklistText) {(err,ref) in
            self.titleChecklist.text = ""
            self.dismiss(animated: true, completion: nil)
        }
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
   
    

