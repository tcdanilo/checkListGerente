//
//  PostService.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 20/05/24.
//

import UIKit
import Firebase

struct ChecklistItem {
    var title: String
    var isComplete : Bool
    var id : String
    var assignedUsers : [String]
  
    
    init(keyID : String, dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.isComplete = dictionary["isComplete"] as? Bool ?? false
        self.id = dictionary["id"] as? String ?? ""
        self.assignedUsers = dictionary["assignedUsers"] as? [String] ?? []
        
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
    
    func fetchAllItems(completion: @escaping([ChecklistItem]) -> Void) {
        
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
    
    func fetchSingleitem(id : String, completion : @escaping(ChecklistItem) -> Void) {
        db_reference.child("items").child(id).observeSingleEvent(of:.value) {
            (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let checklistItem = ChecklistItem(keyID: id, dictionary: dictionary)
            completion(checklistItem)
        }
    }
    func uploadChecklistItem(text : String, completion : @escaping(Error?, DatabaseReference) -> Void) {
        let values = ["title" : text ,
                      "isComplete" : false,
                     ] as [String : Any]
        
        let id = db_reference.child("items").childByAutoId()
        id.updateChildValues(values,withCompletionBlock: completion)
     
        id.updateChildValues(values) {(err, ref) in
            let value = ["id" : id.key!]
            db_reference.child("items").child(id.key!).updateChildValues(value, withCompletionBlock: completion)
        }
      
        
       
    }
    

   
    // inserir novo usuario no database
    public func insertUser(with user: AppUser) {
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
    
    func fetchAllUsers(completion: @escaping ([AppUser]) -> Void) {
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
        
    

    
}
