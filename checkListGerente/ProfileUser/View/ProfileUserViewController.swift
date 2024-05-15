//
//  ProfileUserViewController.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 15/05/24.
//

import UIKit

class ProfileUserViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    let img : UIImageView = {
        let l = UIImageView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.contentMode = .scaleAspectFill
        l.layer.cornerRadius = 75 // Ajuste conforme necessário
        l.clipsToBounds = true
        l.image = UIImage(systemName: "person.crop.square.fill")
        l.tintColor = .label
        return l
    }()
    
    lazy var addImageButton : UIButton = {
        let i = UIButton(type: .system)
        i.translatesAutoresizingMaskIntoConstraints = false
        i.setTitle("Adicionar Foto", for: .normal)
        i.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
       return i
    }()
    
    let usuario : UILabel = {
        let ed = UILabel()
        ed.text = "Adelson pires"
        ed.font = UIFont.systemFont(ofSize: 30)
        ed.textColor = .label
        ed.translatesAutoresizingMaskIntoConstraints = false
        return ed
    }()
    
    let changePassword : UIButton = {
        let ed = UIButton(type: .system)
        ed.translatesAutoresizingMaskIntoConstraints = false
        ed.tintColor = .systemRed
        ed.setTitle("Alterar senha", for: .normal)
        return ed
        
    }()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Perfil"
        view.addSubview(img)
        view.addSubview(addImageButton)
        view.addSubview(usuario)
        view.addSubview(changePassword)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sair", style: .done, target: self, action: #selector(logoffTapped))
        navigationItem.rightBarButtonItem?.tintColor = .red
        
        
        let imgConstraints = [
            img.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            img.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            img.widthAnchor.constraint(equalToConstant: 200),
            img.heightAnchor.constraint(equalToConstant: 200)
        ]
        let imageButtonConstraints = [
            addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addImageButton.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 10)
        
        ]
        let usuarioConstraints = [
            usuario.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usuario.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 20)
        ]
        let changePasswordConstraints = [
            changePassword.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changePassword.topAnchor.constraint(equalTo: usuario.bottomAnchor, constant: 20)
            
        ]
       
       
        NSLayoutConstraint.activate(changePasswordConstraints)
        NSLayoutConstraint.activate(imgConstraints)
        NSLayoutConstraint.activate(imageButtonConstraints)
        NSLayoutConstraint.activate(usuarioConstraints)
      
    }
   
    @objc func addImageTapped() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            let alertController = UIAlertController(title: "Adicionar Foto", message: nil, preferredStyle: .actionSheet)
            
            let choosePhotoAction = UIAlertAction(title: "Escolher Foto", style: .default) { _ in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(choosePhotoAction)
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let takePhotoAction = UIAlertAction(title: "Tirar Foto", style: .default) { _ in
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                }
                alertController.addAction(takePhotoAction)
            }
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    
    @objc func logoffTapped() {
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             
                img.image = pickedImage
            }
            picker.dismiss(animated: true, completion: nil)
        }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    

  

}

