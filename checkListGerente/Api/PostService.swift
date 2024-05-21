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
    
    init(keyID : String, dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.isComplete = dictionary["isComplete"] as? Bool ?? false
        self.id = dictionary["id"] as? String ?? ""
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
        let values = ["title" : text , "isComplete" : false] as [String : Any]
        
        let id = db_reference.child("items").childByAutoId()
        id.updateChildValues(values,withCompletionBlock: completion)
     
        id.updateChildValues(values) {(err, ref) in
            let value = ["id" : id.key!]
            db_reference.child("items").child(id.key!).updateChildValues(value, withCompletionBlock: completion)
        }
      
        
       
    }
    
    func updateItemStatus(checklistID :String ,isComplete : Bool, completion : @escaping(Error?, DatabaseReference) -> Void) {
        let value = ["isComplete": isComplete]
        db_reference.child("items").child(checklistID).updateChildValues(value, withCompletionBlock: completion)
    }
    
    
}
