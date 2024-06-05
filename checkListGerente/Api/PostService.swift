//
//  PostService.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 20/05/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

struct ChecklistItem {
    var title: String
    var isComplete : Bool
    var id : String
    var assignedUser : AppUser?
   // var date : Date?
    
    
    init(keyID : String, dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.isComplete = dictionary["isComplete"] as? Bool ?? false
        self.id = dictionary["id"] as? String ?? ""
        if let assignedUserDict = dictionary["assignedUser"] as? [String: String] {
            self.assignedUser = AppUser(name: assignedUserDict["name"] ?? "", email: assignedUserDict["email"] ?? "")
        } else {
            self.assignedUser = nil
        }
//        /if let timestamp = dictionary["date"] as? TimeInterval {
//                    self.date = Date(timeIntervalSince1970: timestamp)
//                } else {
//                    self.date = nil
//                }
        
    }
}

struct AppUser {
    let name: String
    let email: String
    
    var safeEmail : String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }

    
}

struct PostService {
    
    static let shared = PostService()
    let db_reference = Database.database().reference()
    let storage_reference = Storage.storage().reference()
    
    
    
    
    public func fetchAllItemsAdmin(completion: @escaping([ChecklistItem]) -> Void) {
        
        var allItems = [ChecklistItem]()
        
        db_reference.child("items")
            .queryOrdered(byChild: "isComplete")
            .observe(.childAdded) { (snapshot) in
 
                fetchSingleitem(id: snapshot.key) {(item) in
                    allItems.append(item)
                    completion(allItems)
                        }
            }
}
    public func fetchAllItems(for user: AppUser, completion: @escaping ([ChecklistItem]) -> Void) {
            var allItems = [ChecklistItem]()
        let userEmail = user.email
            print("Fetching items for user: \(userEmail)")
            
            db_reference.child("items")
                .queryOrdered(byChild: "assignedUser/email")
                .queryEqual(toValue: userEmail)
                .observe(.childAdded) { (snapshot) in
                    self.fetchSingleitem(id: snapshot.key) { item in
                        print("Fetched item: \(item.title)")
                        allItems.append(item)
                        completion(allItems)
                    }
                }
        }
    
    
    
    public func fetchSingleitem(id : String, completion : @escaping(ChecklistItem) -> Void) {
        db_reference.child("items").child(id).observeSingleEvent(of:.value) {
            (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let checklistItem = ChecklistItem(keyID: id, dictionary: dictionary)
            completion(checklistItem)
        }
    }
    
    public func updateChecklistItemCompletionStatus(checklistID: String, isComplete: Bool, completion: @escaping (Error?, DatabaseReference) -> Void) {
        // Verifica se o checklistID não está vazio e não contém caracteres especiais
            guard !checklistID.isEmpty else {
                completion(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Checklist ID is empty"]), db_reference)
                return
            }
            
            // Verifica se o checklistID contém caracteres especiais
            let invalidCharacters = CharacterSet(charactersIn: ".#$/[]")
            guard checklistID.rangeOfCharacter(from: invalidCharacters) == nil else {
                completion(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Checklist ID contains invalid characters"]), db_reference)
                return
            }
            
            let value = ["isComplete": isComplete]
            db_reference.child("items").child(checklistID).updateChildValues(value, withCompletionBlock: completion)
    }
    
    
    public func uploadChecklistItem(text : String,assignedUser : AppUser?, completion : @escaping(Error?, DatabaseReference) -> Void) {
        
        let userDict = ["name": assignedUser?.name, "email": assignedUser?.email]
        let values : [String: Any] = [
                      "title" : text ,
                      "isComplete" : false,
                      "assignedUser": userDict
                      //"date" : date.timeIntervalSince1970
                     ] as [String : Any]
        
        let id = db_reference.child("items").childByAutoId()
        id.updateChildValues(values,withCompletionBlock: completion)
     
        id.updateChildValues(values) {(err, ref) in
            let value = ["id" : id.key!]
            db_reference.child("items").child(id.key!).updateChildValues(value, withCompletionBlock: completion)
        }
      
        
       
    }
    

   
    // inserir novo usuario no database
    public func insertUser(with user: AppUser, uid: String) {
        db_reference.child("users").child(user.safeEmail).setValue([
            "first_name": user.name,
            "email" : user.email
        ])
        
    }
    
    
    public func userExists(with email: String, completion : @escaping ((Bool)) -> Void){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        db_reference.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
   public func fetchAllUsers(completion: @escaping ([AppUser]) -> Void) {
        db_reference.child("users").observeSingleEvent(of: .value) { snapshot in
                    guard let usersDictionary = snapshot.value as? [String: [String: Any]] else {
                        completion([])
                        return
                    }
                    
                    var allUsers = [AppUser]()
                    
                    for (_, userData) in usersDictionary {
                        if let name = userData["first_name"] as? String,
                           let email = userData["email"] as? String {
                            let user = AppUser(name: name, email: email)
                            allUsers.append(user)
                        }
                    }
                    
                    completion(allUsers)
                }
            }
        
    public func updateAssignedUser(checklistID : String, appUser : AppUser, completion : @escaping(Error?, DatabaseReference) -> Void) {
        
        let value = ["assignedUser": appUser]
        db_reference.child("items").child(checklistID).updateChildValues(value,withCompletionBlock: completion)
        
        
    }
    public func fetchUserName(completion: @escaping (String?) -> Void) {
            guard let user = Auth.auth().currentUser else {
                completion(nil)
                return
            }
            let userEmail = user.email ?? ""
            let safeEmail = userEmail.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
            
            let ref = db_reference.child("users").child(safeEmail)
            ref.observeSingleEvent(of: .value) { snapshot, _ in
                guard let value = snapshot.value as? [String: Any],
                      let name = value["first_name"] as? String else {
                    completion(nil)
                    return
                }
                completion(name)
            }
        }
    
    func fetchUserProfile(completion: @escaping (AppUser?, String?) -> Void) {
            guard let uid = Auth.auth().currentUser?.uid else {
                completion(nil, nil)
                return
            }

            let userRef = db_reference.child("users").child(uid)

            userRef.observeSingleEvent(of: .value) { snapshot in
                guard let userData = snapshot.value as? [String: Any] else {
                    completion(nil, nil)
                    return
                }

                let name = userData["first_name"] as? String ?? ""
                let email = userData["email"] as? String ?? ""
                let profileImageURL = userData["profileImageURL"] as? String

                let user = AppUser(name: name, email: email)
                completion(user, profileImageURL)
            }
        }
        
        // Método para carregar a imagem do perfil
    func loadProfileImage(from url: String, completion: @escaping (UIImage?) -> Void) {
            guard let imageURL = URL(string: url) else {
                completion(nil)
                return
            }

            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    

    
}

