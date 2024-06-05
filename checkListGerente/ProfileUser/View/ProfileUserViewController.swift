//
//  ProfileUserViewController.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 15/05/24.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Firebase

class ProfileUserViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    
    let img: UIImageView = {
        let l = UIImageView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.contentMode = .scaleAspectFill
        l.layer.cornerRadius = 75
        l.clipsToBounds = true
        l.image = UIImage(systemName: "person.crop.circle.fill")
        l.tintColor = .label
        l.layer.borderWidth = 2
        l.layer.borderColor = UIColor.systemGray4.cgColor
        return l
    }()

    lazy var addImageButton: UIButton = {
        let i = UIButton(type: .system)
        i.translatesAutoresizingMaskIntoConstraints = false
        i.setTitle("Adicionar Foto", for: .normal)
        i.setTitleColor(.white, for: .normal)
        i.backgroundColor = .systemBlue
        i.layer.cornerRadius = 10
        i.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
        return i
    }()

    let usuario: UILabel = {
        let ed = UILabel()
        ed.text = ""
        ed.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        ed.textColor = .label
        ed.translatesAutoresizingMaskIntoConstraints = false
        return ed
    }()

    let changePassword: UIButton = {
        let ed = UIButton(type: .system)
        ed.translatesAutoresizingMaskIntoConstraints = false
        ed.setTitle("Alterar senha", for: .normal)
        ed.setTitleColor(.systemRed, for: .normal)
        ed.layer.borderWidth = 1
        ed.layer.borderColor = UIColor.systemRed.cgColor
        ed.layer.cornerRadius = 10
        ed.addTarget(self, action: #selector(changePasswordDidTap), for: .touchUpInside)
        return ed
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Perfil"
        view.backgroundColor = .systemBackground
        view.addSubview(img)
        view.addSubview(addImageButton)
        view.addSubview(usuario)
        view.addSubview(changePassword)
        setupLayout()
        fetchUserName()
        fetchUserProfile()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sair", style: .done, target: self, action: #selector(logoffTapped))
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
    }

    func setupLayout() {
        let imgConstraints = [
            img.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            img.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            img.widthAnchor.constraint(equalToConstant: 150),
            img.heightAnchor.constraint(equalToConstant: 150)
        ]
        let imageButtonConstraints = [
            addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addImageButton.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 20),
            addImageButton.widthAnchor.constraint(equalToConstant: 140),
            addImageButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        let usuarioConstraints = [
            usuario.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usuario.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 30)
        ]
        let changePasswordConstraints = [
            changePassword.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changePassword.topAnchor.constraint(equalTo: usuario.bottomAnchor, constant: 20),
            changePassword.widthAnchor.constraint(equalToConstant: 140),
            changePassword.heightAnchor.constraint(equalToConstant: 40)
        ]

        NSLayoutConstraint.activate(imgConstraints)
        NSLayoutConstraint.activate(imageButtonConstraints)
        NSLayoutConstraint.activate(usuarioConstraints)
        NSLayoutConstraint.activate(changePasswordConstraints)
    }

    func fetchUserName() {
        PostService.shared.fetchUserName { [weak self] name in
            guard let self = self else { return }
            self.usuario.text = name ?? "Nome não encontrado"
        }
    }


    func fetchUserProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users").child(uid)
        
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? [String: Any] {
                if let name = value["name"] as? String {
                    DispatchQueue.main.async {
                        self.usuario.text = name
                    }
                }
                
                if let profileImageURL = value["profileImageURL"] as? String {
                    self.loadProfileImage(from: profileImageURL)
                }
            }
        }
    }

    func loadProfileImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("Failed to download image: \(error.localizedDescription)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to convert data to image")
                return
            }
            DispatchQueue.main.async {
                self.img.image = image
            }
        }
        task.resume()
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc func logoffTapped() {
        do {
            try Auth.auth().signOut()
            if let window = UIApplication.shared.windows.first {
                let signInVC = SignInViewController()
                let navController = UINavigationController(rootViewController: signInVC)
                navController.modalPresentationStyle = .fullScreen
                window.rootViewController = navController
                window.makeKeyAndVisible()
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            let alert = UIAlertController(title: "Erro", message: "Falha ao sair: \(signOutError.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    @objc func changePasswordDidTap() {
        guard let currentUser = Auth.auth().currentUser else {
            showError(message: "Não há usuário logado.")
            return
        }

        let email = currentUser.email ?? ""
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                print("Erro ao enviar e-mail de redefinição de senha:", error.localizedDescription)
                self.showError(message: "Erro ao enviar e-mail de redefinição de senha.")
            } else {
                print("E-mail de redefinição de senha enviado com sucesso.")
                let alert = UIAlertController(title: "Sucesso", message: "Um e-mail de redefinição de senha foi enviado para \(email).", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            img.image = pickedImage
            uploadProfileImage(pickedImage) { url in
                if let url = url {
                    self.saveProfileImageURL(url.absoluteString)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func uploadProfileImage(_ image: UIImage, completion: @escaping (_ url: URL?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("profile_images").child("\(uid).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                completion(url)
            }
        }
    }

    func saveProfileImageURL(_ url: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users").child(uid)
        databaseRef.updateChildValues(["profileImageURL": url]) { error, _ in
            if let error = error {
                print("Failed to save profile image URL: \(error.localizedDescription)")
            } else {
                print("Profile image URL saved successfully")
            }
        }
    }
    
}
